/// PhotoUploadService tests.
///
/// The BFF calls (request presigned POST + finalize) are mocked with
/// http_mock_adapter; the S3 upload uses a tiny fake HttpClientAdapter so the
/// multipart body and absolute URL are handled deterministically.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dating_app_verification/core/network/api_exceptions.dart';
import 'package:dating_app_verification/services/photo_upload_service.dart';

/// Records the S3 upload request and returns a caller-chosen status.
class _FakeUploadAdapter implements HttpClientAdapter {
  _FakeUploadAdapter({this.status = 204});
  final int status;
  String? lastUrl;
  String? lastContentType;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastUrl = options.uri.toString();
    lastContentType = options.contentType;
    return ResponseBody.fromString(
      '',
      status,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const uploadUrl = 'https://s3.ap-south-1.amazonaws.com/elyxer-photos';
  const path = 'users/uid-1/photos/x.jpg';
  final bytes = Uint8List.fromList([1, 2, 3]);

  late Dio bffDio;
  late DioAdapter bffAdapter;
  late _FakeUploadAdapter uploadAdapter;
  late PhotoUploadService service;

  void wire({int uploadStatus = 204}) {
    bffDio = Dio(
      BaseOptions(baseUrl: 'https://api.test', validateStatus: (_) => true),
    );
    bffAdapter = DioAdapter(dio: bffDio);
    uploadAdapter = _FakeUploadAdapter(status: uploadStatus);
    final uploader = Dio()..httpClientAdapter = uploadAdapter;
    service = PhotoUploadService(dio: bffDio, uploader: uploader);
  }

  void stubRequestUrl({int status = 200}) {
    bffAdapter.onPost(
      '/requestPhotoUploadUrl',
      (server) => server.reply(status, {
        'upload': {
          'url': uploadUrl,
          'fields': {
            'key': path,
            'Content-Type': 'image/jpeg',
            'Policy': 'base64policy',
            'X-Amz-Signature': 'sig',
          },
        },
        'storagePath': path,
        'contentType': 'image/jpeg',
        'maxBytes': 10485760,
        'expiresInMs': 300000,
      }),
      data: {'position': 0, 'isSelfie': false},
    );
  }

  test('happy path: requests POST, uploads bytes, finalizes, returns the photo',
      () async {
    wire();
    stubRequestUrl();
    bffAdapter.onPost(
      '/finalizePhotoUpload',
      (server) => server.reply(201, {
        'photo': {'storage_path': path, 'position': 0},
      }),
      data: {
        'storagePath': path,
        'position': 0,
        'isSelfie': false,
        'widthPx': 100,
        'heightPx': 200,
      },
    );

    final result = await service.upload(
      bytes: bytes,
      position: 0,
      isSelfie: false,
      widthPx: 100,
      heightPx: 200,
    );

    expect(result.storagePath, path);
    expect(result.position, 0);
    expect(uploadAdapter.lastUrl, uploadUrl, reason: 'POST hit the S3 URL');
    expect(uploadAdapter.lastContentType, startsWith('multipart/form-data'));
  });

  test('a taken slot (409 on finalize) throws ValidationException', () async {
    wire();
    stubRequestUrl();
    bffAdapter.onPost(
      '/finalizePhotoUpload',
      (server) => server.reply(409, {
        'error': 'A photo already occupies this slot. Replace it first.',
      }),
      data: {
        'storagePath': path,
        'position': 0,
        'isSelfie': false,
        'widthPx': null,
        'heightPx': null,
      },
    );

    expect(
      () => service.upload(bytes: bytes, position: 0, isSelfie: false),
      throwsA(isA<ValidationException>()),
    );
  });

  test('an over-limit object (413 on finalize) throws ValidationException',
      () async {
    wire();
    stubRequestUrl();
    bffAdapter.onPost(
      '/finalizePhotoUpload',
      (server) => server.reply(413, {'error': 'Uploaded photo exceeds the size limit.'}),
      data: {
        'storagePath': path,
        'position': 0,
        'isSelfie': false,
        'widthPx': null,
        'heightPx': null,
      },
    );

    expect(
      () => service.upload(bytes: bytes, position: 0, isSelfie: false),
      throwsA(isA<ValidationException>()),
    );
  });

  test('a foreign/expired request (403) throws AuthException', () async {
    wire();
    stubRequestUrl(status: 403);

    expect(
      () => service.upload(bytes: bytes, position: 0, isSelfie: false),
      throwsA(isA<AuthException>()),
    );
  });

  test('a failed storage upload throws PhotoUploadException', () async {
    wire(uploadStatus: 500);
    stubRequestUrl();

    expect(
      () => service.upload(bytes: bytes, position: 0, isSelfie: false),
      throwsA(isA<PhotoUploadException>()),
    );
  });
}
