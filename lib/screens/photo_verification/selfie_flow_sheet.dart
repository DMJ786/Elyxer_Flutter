/// SelfieFlowSheet — full-screen modal hosting the 3-state selfie
/// verification flow (capture → reject/confirm → save).
///
/// Presented via showGeneralDialog with a slide-up transition (mirrors
/// the gender_identity_sheet.dart pattern). The container holds the
/// state machine; each child view is stateless and independently
/// testable.
///
/// Capture flow:
///   user taps Capture
///     → photoPickerServiceProvider.pickFromCamera(preferred: front)
///     → switch on PhotoPickResult:
///         Success(file)        → selfieValidatorServiceProvider.validate(file)
///                                → SelfieValid           → confirmation state
///                                → SelfieInvalid(reason) → rejection state
///                                → SelfieValidationError → rejection state, no reason
///         PermissionDenied     → SnackBar with "Open Settings" if permanent
///         Error                → rejection state, no reason
///         Cancelled            → stay on capture state
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/photo_picker_provider.dart';
import '../../providers/photo_verification_provider.dart';
import '../../providers/selfie_validator_provider.dart';
import '../../services/photo_picker_service.dart';
import '../../services/selfie_validator_service.dart';
import 'selfie_capture_view.dart';
import 'selfie_confirmation_view.dart';
import 'selfie_rejection_view.dart';

Future<void> showSelfieFlowSheet(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Selfie',
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _SelfieFlowSheet();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.0, 1.0), // slide up from bottom
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

enum _SelfieState { capture, rejection, confirmation }

class _SelfieFlowSheet extends ConsumerStatefulWidget {
  const _SelfieFlowSheet();

  @override
  ConsumerState<_SelfieFlowSheet> createState() => _SelfieFlowSheetState();
}

class _SelfieFlowSheetState extends ConsumerState<_SelfieFlowSheet> {
  _SelfieState _state = _SelfieState.capture;
  XFile? _attemptedFile;
  SelfieRejectionReason? _rejectionReason;

  Future<void> _onCapture() async {
    final picker = ref.read(photoPickerServiceProvider);
    final pickResult = await picker.pickFromCamera(
      preferred: PhotoCameraDevice.front,
    );
    if (!mounted) return;

    switch (pickResult) {
      case PhotoPickSuccess(:final file):
        // Validate via ML Kit. Even if validation fails, we keep the
        // file reference so the rejection view can show it blurred.
        final validator = ref.read(selfieValidatorServiceProvider);
        final validation = await validator.validate(file);
        if (!mounted) return;
        switch (validation) {
          case SelfieValid():
            setState(() {
              _attemptedFile = file;
              _rejectionReason = null;
              _state = _SelfieState.confirmation;
            });
          case SelfieInvalid(:final reason):
            setState(() {
              _attemptedFile = file;
              _rejectionReason = reason;
              _state = _SelfieState.rejection;
            });
          case SelfieValidationError():
            setState(() {
              _attemptedFile = file;
              _rejectionReason = null;
              _state = _SelfieState.rejection;
            });
        }
      case PhotoPickPermissionDenied(:final permanently):
        if (permanently) _showOpenSettings(picker);
      case PhotoPickError():
        setState(() {
          _attemptedFile = null;
          _rejectionReason = null;
          _state = _SelfieState.rejection;
        });
      case PhotoPickCancelled():
        break;
    }
  }

  void _onRetake() {
    setState(() {
      _attemptedFile = null;
      _rejectionReason = null;
      _state = _SelfieState.capture;
    });
  }

  void _onSubmit() {
    final file = _attemptedFile;
    if (file == null) return;
    final notifier = ref.read(photoVerificationDataProvider.notifier);
    notifier.setSelfie(file.path);
    notifier.markSelfieVerified();
    Navigator.of(context).pop();
  }

  void _onDismiss() {
    Navigator.of(context).pop();
  }

  void _showOpenSettings(PhotoPickerService picker) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is denied. Open Settings to allow.',
          ),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: picker.openSettings,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: switch (_state) {
        _SelfieState.capture => SelfieCaptureView(
            onCapture: _onCapture,
            onAddLater: _onDismiss,
            onClose: _onDismiss,
          ),
        _SelfieState.rejection => SelfieRejectionView(
            attemptedFile: _attemptedFile,
            reason: _rejectionReason,
            onRetake: _onRetake,
            onAddLater: _onDismiss,
          ),
        _SelfieState.confirmation => SelfieConfirmationView(
            selfieFile: _attemptedFile!,
            onRetake: _onRetake,
            onSubmit: _onSubmit,
          ),
      },
    );
  }
}
