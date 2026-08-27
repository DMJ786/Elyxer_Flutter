/// ShareMomentScreen — compose a new moment or edit an existing one:
/// a candid thought (text) and/or photo, tagged with a mood.
library;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/moment_models.dart';
import '../../providers/moments_provider.dart';
import '../../theme/app_theme.dart';
import 'moment_popups.dart';
import 'widgets/moment_widgets.dart';

const Color _goldMedium = Color(0xFFC29240);

class ShareMomentScreen extends ConsumerStatefulWidget {
  const ShareMomentScreen({super.key, this.editing});

  /// Non-null when editing one of the user's own moments.
  final Moment? editing;

  @override
  ConsumerState<ShareMomentScreen> createState() => _ShareMomentScreenState();
}

class _ShareMomentScreenState extends ConsumerState<ShareMomentScreen> {
  late final TextEditingController _controller;
  final GlobalKey _cropKey = GlobalKey();
  Mood? _mood;

  /// A freshly picked photo (network/blob URL) awaiting align.
  String? _imageUrl;

  /// An already-baked photo (edit mode) shown in the aligner.
  Uint8List? _existingBytes;
  static const int _wordLimit = 25;

  bool get _isEditing => widget.editing != null;
  bool get _hasImage => _imageUrl != null || _existingBytes != null;

  // Opens the gallery / file chooser, then lets the user zoom/align.
  Future<void> _pickImage() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (file != null && mounted) {
      setState(() {
        _imageUrl = file.path;
        _existingBytes = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.editing?.text ?? '');
    _mood = widget.editing?.mood;
    _imageUrl = widget.editing?.imageUrl;
    _existingBytes = widget.editing?.imageBytes;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _wordCount {
    final String t = _controller.text.trim();
    return t.isEmpty ? 0 : t.split(RegExp(r'\s+')).length;
  }

  bool get _canShare =>
      (_controller.text.trim().isNotEmpty || _hasImage) &&
      _wordCount <= _wordLimit;

  /// Rasterise the aligned crop frame to PNG bytes (WYSIWYG).
  Future<Uint8List?> _captureCrop() async {
    final BuildContext? ctx = _cropKey.currentContext;
    if (ctx == null) return null;
    final RenderRepaintBoundary boundary =
        ctx.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.5);
    final ByteData? data =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  Future<void> _share() async {
    final MomentsFeed feed = ref.read(momentsFeedProvider.notifier);
    final String text = _controller.text.trim();
    final Uint8List? bytes = _hasImage ? await _captureCrop() : null;
    if (!mounted) return;
    if (_isEditing) {
      await feed.edit(widget.editing!.id,
          text: text, imageBytes: bytes, mood: _mood);
    } else {
      await feed.share(text: text, imageBytes: bytes, mood: _mood);
    }
    if (!mounted) return;
    showMomentSharedToast(context);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _Header(editing: _isEditing),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      'Add a candid moment from your life.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.interactive300,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _InputField(
                      controller: _controller,
                      wordCount: _wordCount,
                      wordLimit: _wordLimit,
                      cropKey: _cropKey,
                      imageUrl: _imageUrl,
                      imageBytes: _existingBytes,
                      hasImage: _hasImage,
                      onChanged: () => setState(() {}),
                      onAttach: _pickImage,
                      onRemoveImage: () => setState(() {
                        _imageUrl = null;
                        _existingBytes = null;
                      }),
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    Row(
                      children: <Widget>[
                        const Expanded(child: Divider(color: AppColors.interactive100)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.x3),
                          child: Text(
                            'SELECT YOUR MOOD',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.interactive300,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.interactive100)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    MoodGrid(
                      selected: _mood,
                      onSelect: (Mood m) => setState(
                          () => _mood = _mood == m ? null : m),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                  ],
                ),
              ),
            ),
            _Footer(
              canShare: _canShare,
              onCancel: () => context.pop(),
              onShare: _share,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.editing});

  final bool editing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2, vertical: AppSpacing.x2),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.interactive400),
          ),
          Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: editing ? 'Edit ' : 'Share a ',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.interactive500,
                  ),
                  children: <InlineSpan>[
                    TextSpan(
                      text: 'Moment',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: _goldMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.wordCount,
    required this.wordLimit,
    required this.cropKey,
    required this.imageUrl,
    required this.imageBytes,
    required this.hasImage,
    required this.onChanged,
    required this.onAttach,
    required this.onRemoveImage,
  });

  final TextEditingController controller;
  final int wordCount;
  final int wordLimit;
  final GlobalKey cropKey;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool hasImage;
  final VoidCallback onChanged;
  final VoidCallback onAttach;
  final VoidCallback onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final bool over = wordCount > wordLimit;
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x4, AppSpacing.x4, AppSpacing.x4, AppSpacing.x2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.interactive50),
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.interactive100, blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(Icons.format_quote, size: 16, color: _goldMedium),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: hasImage ? 2 : 5,
                  maxLines: hasImage ? 4 : 8,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (_) => onChanged(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 20 / 14,
                    color: AppColors.interactive400,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'A thought, a feeling, a small wonder...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppColors.interactive300,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasImage) ...<Widget>[
            const SizedBox(height: AppSpacing.x3),
            Stack(
              children: <Widget>[
                // Only the framed crop is captured — the X sits outside it.
                RepaintBoundary(
                  key: cropKey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: ColoredBox(
                        color: AppColors.interactive50,
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 5,
                          clipBehavior: Clip.hardEdge,
                          child: imageBytes != null
                              ? Image.memory(imageBytes!, fit: BoxFit.cover)
                              : Image.network(imageUrl!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: InkWell(
                    onTap: onRemoveImage,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x2, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                    child: Text(
                      'Pinch / scroll to zoom · drag to align',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: onAttach,
                icon: const Icon(Icons.add_photo_alternate_outlined,
                    color: _goldMedium),
                tooltip: 'Attach photo',
              ),
              const Spacer(),
              Text(
                '${wordCount.toString().padLeft(2, '0')}/$wordLimit words',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: over ? const Color(0xFFBD4A44) : AppColors.interactive300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.canShare,
    required this.onCancel,
    required this.onShare,
  });

  final bool canShare;
  final VoidCallback onCancel;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.x5, AppSpacing.x3, AppSpacing.x5,
          AppSpacing.x3 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.interactive100)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: AppColors.interactive300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.interactive300,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: SizedBox(
              height: 48,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: canShare ? onShare : null,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: canShare ? AppColors.brandGradient : null,
                      color: canShare ? null : AppColors.interactive100,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Center(
                      child: Text(
                        'Share Moment',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: canShare ? Colors.white : AppColors.interactive300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
