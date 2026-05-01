/// Riverpod provider for the photo picker service.
/// Tests override with `photoPickerServiceProvider.overrideWithValue(...)`.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/photo_picker_service.dart';

part 'photo_picker_provider.g.dart';

@riverpod
PhotoPickerService photoPickerService(Ref ref) =>
    ImagePickerPhotoPickerService();
