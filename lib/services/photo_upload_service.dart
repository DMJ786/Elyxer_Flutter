/// Photo upload service (Module 5).
///
/// Implements the direct-to-Cloud-Storage upload: request a scoped signed URL
/// from the BFF, PUT the bytes straight to Storage, then finalize (record the
/// object). The BFF calls go through [ApiClient] (auth interceptor attaches the
/// token); the signed-URL PUT uses a separate bare Dio, because a GCS signed
/// URL must NOT carry an Authorization header — the signature is in the query.
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

/// Raised when the direct-to-Storage PUT (not a BFF call) fails.
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

  /// Bare client for the signed-URL PUT (absolute URL, no interceptors).
  final Dio _uploader;

  static const String _requestPath = '/requestPhotoUploadUrl';
  static const String _finalizePath = '/finalizePhotoUpload';

  /// Uploads [bytes] into the given grid [position] (0..4 regular, 5 selfie)
  /// and returns the recorded photo. Throws [ApiException] on a BFF failure or
  /// [PhotoUploadException] if the storage PUT fails.
  Future<UploadedPhoto> upload({
    required Uint8List bytes,
    required int position,
    required bool isSelfie,
    int? widthPx,
    int? heightPx,
  }) async {
    // 1. Ask the BFF for a scoped, short-lived signed URL.
    final reqRes = await _dio.post<dynamic>(
      _requestPath,
      data: {'position': position, 'isSelfie': isSelfie},
    );
    _ensure2xx(reqRes);
    final reqBody = (reqRes.data as Map).cast<String, dynamic>();
    final uploadUrl = reqBody['uploadUrl'] as String;
    final storagePath = reqBody['storagePath'] as String;
    final contentType = (reqBody['contentType'] as String?) ?? 'image/jpeg';

    // 2. PUT the raw bytes straight to Cloud Storage.
    try {
      await _uploader.put<void>(
        uploadUrl,
        data: Stream<List<int>>.fromIterable(<List<int>>[bytes]),
        options: Options(
          contentType: contentType,
          headers: {Headers.contentLengthHeader: bytes.length},
        ),
      );
    } on DioException catch (e) {
      throw PhotoUploadException(
        'Uploading the photo failed. Please try again.',
        cause: e,
      );
    }

    // 3. Record the object against the user's slot.
    final finRes = await _dio.post<dynamic>(
      _finalizePath,
      data: {
        'storagePath': storagePath,
        'position': position,
        'isSelfie': isSelfie,
        'widthPx': widthPx,
        'heightPx': heightPx,
        'sizeBytes': bytes.length,
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
    if (status == 400 || status == 409 || status == 422) {
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
