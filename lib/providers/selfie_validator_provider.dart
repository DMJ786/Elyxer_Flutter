/// Riverpod provider for the selfie validator service.
///
/// keepAlive: true so the underlying ML Kit FaceDetector instance is
/// reused across the entire selfie flow (creating one is expensive —
/// model load + native init takes a noticeable fraction of a second).
/// onDispose closes the detector when the provider is finally torn down.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/selfie_validator_service.dart';

part 'selfie_validator_provider.g.dart';

@Riverpod(keepAlive: true)
SelfieValidatorService selfieValidatorService(Ref ref) {
  final service = MlKitSelfieValidatorService();
  ref.onDispose(service.dispose);
  return service;
}
