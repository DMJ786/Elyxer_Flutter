/// PlatformImage — displays a user-picked/captured image by path across
/// mobile and web.
///
/// On mobile the path returned by image_picker is a real file system path
/// that `Image.file` can load. On Flutter web it's a `blob:` URL that
/// `dart:io File` can't open — `Image.network` handles it fine.
library;

import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

class PlatformImage extends StatelessWidget {
  const PlatformImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(path, width: width, height: height, fit: fit);
    }
    return Image.file(File(path), width: width, height: height, fit: fit);
  }
}
