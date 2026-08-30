/// Photo upload service (Module 5).
///
/// Implements the direct-to-S3 upload: request a scoped, short-lived presigned
/// POST from the BFF, upload the bytes straight to S3 as multipart/form-data
/// (the POST policy locks content-type + size), then finalize (record the
/// object; the BFF re-checks the real object size). The BFF calls go through
/// [ApiClient] (auth interceptor attaches the token); the S3 upload uses a
/// separate bare Dio, because a presigned POST must NOT carry an Authorization
/// header — the signature is in the form fields.
library;

import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/network/api_exceptions.dart';

/// The object recorded by the BFF after a successful upload.
class UploadedPhoto {
  const UploadedPhoto({required this.storagePath, required this.position});

  final String storagePath;
  final int position;
}

/// Raised when the direct-to-S3 upload (not a BFF call) fails.
class PhotoUploadException implements Exception {
  const PhotoUploadException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => 'PhotoUploadException: $message';
}

class PhotoUploadService {
  PhotoUploadService({Dio? dio, Dio? uploader})
    : _dio = dio ?? ApiClient.instance.dio,
      _uploader = uploader ?? Dio();

  /// BFF client (baseUrl + auth interceptor).
  final Dio _dio;

  /// Bare client for the S3 presigned POST (absolute URL, no interceptors).
  final Dio _uploader;

  static const String _requestPath = '/requestPhotoUploadUrl';
  static const String _finalizePath = '/finalizePhotoUpload';

  /// Uploads [bytes] into the given grid [position] (0..4 regular, 5 selfie)
  /// and returns the recorded photo. Throws [ApiException] on a BFF failure or
  /// [PhotoUploadException] if the storage upload fails.
  Future<UploadedPhoto> upload({
    required Uint8List bytes,
    required int position,
    required bool isSelfie,
    int? widthPx,
    int? heightPx,
  }) async {
    // 1. Ask the BFF for a scoped, short-lived presigned POST.
    final reqRes = await _dio.post<dynamic>(
      _requestPath,
      data: {'position': position, 'isSelfie': isSelfie},
    );
    _ensure2xx(reqRes);
    final reqBody = (reqRes.data as Map).cast<String, dynamic>();
    final upload = (reqBody['upload'] as Map).cast<String, dynamic>();
    final uploadUrl = upload['url'] as String;
    final fields = (upload['fields'] as Map).cast<String, dynamic>();
    final storagePath = reqBody['storagePath'] as String;

    // 2. POST the bytes straight to S3 (multipart/form-data). The presigned
    //    policy fields must come before the file part.
    try {
      final form = FormData();
      fields.forEach((k, v) => form.fields.add(MapEntry(k, '$v')));
      form.files.add(
        MapEntry('file', MultipartFile.fromBytes(bytes, filename: 'photo.jpg')),
      );
      await _uploader.post<void>(uploadUrl, data: form);
    } on DioException catch (e) {
      throw PhotoUploadException(
        'Uploading the photo failed. Please try again.',
        cause: e,
      );
    }

    // 3. Record the object against the user's slot. Size is NOT sent — the BFF
    //    reads the real object size from S3.
    final finRes = await _dio.post<dynamic>(
      _finalizePath,
      data: {
        'storagePath': storagePath,
        'position': position,
        'isSelfie': isSelfie,
        'widthPx': widthPx,
        'heightPx': heightPx,
      },
    );
    _ensure2xx(finRes);

    return UploadedPhoto(storagePath: storagePath, position: position);
  }

  /// Throws the mapped [ApiException] when [res] is not a 2xx. (The BFF client
  /// uses `validateStatus: (_) => true`, so 4xx/5xx arrive as responses.)
  void _ensure2xx(Response<dynamic> res) {
    final status = res.statusCode ?? 0;
    if (status >= 200 && status < 300) return;
    throw _mapError(status, res.data);
  }

  ApiException _mapError(int status, Object? data) {
    final message = _extractMessage(data) ?? 'Photo upload failed';
    if (status == 401 || status == 403) {
      return AuthException(message, statusCode: status);
    }
    if (status == 400 || status == 409 || status == 413 || status == 422) {
      return ValidationException(message, statusCode: status);
    }
    if (status >= 500) {
      return ServerException(message, statusCode: status);
    }
    return ClientException(message, statusCode: status);
  }

  String? _extractMessage(Object? data) {
    if (data is Map && data['error'] is String) return data['error'] as String;
    return null;
  }
}
