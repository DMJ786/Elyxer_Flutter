/// PhotoUploadService tests.
///
/// The BFF calls (request URL + finalize) are mocked with http_mock_adapter;
/// the signed-URL PUT uses a tiny fake HttpClientAdapter so the streamed body
/// and absolute URL are handled deterministically.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dating_app_verification/core/network/api_exceptions.dart';
import 'package:dating_app_verification/services/photo_upload_service.dart';

/// Records the PUT and returns a caller-chosen status. Never matches on body.
class _FakePutAdapter implements HttpClientAdapter {
  _FakePutAdapter({this.status = 200});
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
  const signedUrl = 'https://storage.googleapis.com/bucket/obj?sig=abc';
  const path = 'users/uid-1/photos/x.jpg';
  final bytes = Uint8List.fromList([1, 2, 3]);

  late Dio bffDio;
  late DioAdapter bffAdapter;
  late _FakePutAdapter putAdapter;
  late PhotoUploadService service;

  void wire({int putStatus = 200}) {
    bffDio = Dio(
      BaseOptions(baseUrl: 'https://api.test', validateStatus: (_) => true),
    );
    bffAdapter = DioAdapter(dio: bffDio);
    putAdapter = _FakePutAdapter(status: putStatus);
    final uploader = Dio()..httpClientAdapter = putAdapter;
    service = PhotoUploadService(dio: bffDio, uploader: uploader);
  }

  void stubRequestUrl({int status = 200}) {
    bffAdapter.onPost(
      '/requestPhotoUploadUrl',
      (server) => server.reply(status, {
        'uploadUrl': signedUrl,
        'storagePath': path,
        'contentType': 'image/jpeg',
      }),
      data: {'position': 0, 'isSelfie': false},
    );
  }

  test('happy path: requests URL, PUTs bytes, finalizes, returns the photo',
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
        'sizeBytes': 3,
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
    expect(putAdapter.lastUrl, signedUrl, reason: 'PUT hit the signed URL');
    expect(putAdapter.lastContentType, 'image/jpeg');
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
        'sizeBytes': 3,
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

  test('a failed storage PUT throws PhotoUploadException', () async {
    wire(putStatus: 500);
    stubRequestUrl();

    expect(
      () => service.upload(bytes: bytes, position: 0, isSelfie: false),
      throwsA(isA<PhotoUploadException>()),
    );
  });
}
