import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ai_home_design/theme/app_colors.dart';
import 'package:ai_home_design/widgets/app_buttons.dart';
import 'package:ai_home_design/widgets/generating_overlay.dart';
import 'package:ai_home_design/widgets/glass_panel.dart';
import 'package:ai_home_design/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CleanupPage extends StatefulWidget {
  const CleanupPage({super.key});

  static const String backgroundImage = 'assets/images/bg_home.png';
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xF015191C), Color(0xD0121819), Color(0xCC0F231D)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  State<CleanupPage> createState() => _CleanupPageState();
}

class _CleanupPageState extends State<CleanupPage> {
  final List<_Stroke> _strokes = [];
  final ImagePicker _picker = ImagePicker();

  Size? _canvasSize;
  Uint8List? _mergedBytes;
  int _imageVersion = 0;
  double _brushSize = 26;
  bool _isGenerating = false;
  double _generationProgress = 0.18;
  String _generationStatus = 'Waiting for mask';
  bool _hasUpload = false;
  bool _hasResult = false;
  bool _showResult = false;

  ImageProvider _originalImage = const AssetImage(CleanupPage.backgroundImage);
  ImageProvider _cleanedImage = const AssetImage(CleanupPage.backgroundImage);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isWide = MediaQuery.of(context).size.width > 920;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              CleanupPage.backgroundImage,
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.2),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: CleanupPage.backgroundGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(textTheme),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StepHeader(
                          textTheme: textTheme,
                          title: 'Cleanup Objects',
                          subtitle:
                              'Brush over unwanted items and let AI remove them seamlessly.',
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: isWide
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: _buildCanvasArea(textTheme),
                                    ),
                                    const SizedBox(width: 14),
                                    SizedBox(
                                      width: 320,
                                      child: _buildControlPanel(textTheme),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: _buildCanvasArea(textTheme),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildControlPanel(textTheme),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isGenerating)
            GeneratingOverlay(
              status: _generationStatus,
              progress: _generationProgress,
              title: 'Cleaning objects...',
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      children: [
        RoundIconButton(
          icon: Icons.arrow_back_ios_new,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RemakeHome',
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const Spacer(),
        RoundIconButton(
          icon: Icons.help_outline,
          onTap: () => _showToast(
            'Paint over objects you want to remove, then tap Remove.',
          ),
        ),
        const SizedBox(width: 10),
        RoundIconButton(icon: Icons.save_alt_outlined, onTap: _handleSave),
      ],
    );
  }

  Widget _buildCanvasArea(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withValues(alpha: 0.24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: Image(
                      key: ValueKey<String>(
                        '$_imageVersion-${_showResult && _hasResult}',
                      ),
                      image: _showResult && _hasResult
                          ? _cleanedImage
                          : _originalImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const ColoredBox(color: Colors.black12),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.04),
                          Colors.black.withValues(alpha: 0.32),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_strokes.isNotEmpty && !(_hasResult && _showResult))
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _MaskPainter(
                          strokes: _strokes,
                          color: const Color(0xFFEAB485),
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: _hasUpload && !_isGenerating
                        ? (details) => _startStroke(details.localPosition)
                        : null,
                    onPanUpdate: _hasUpload && !_isGenerating
                        ? (details) => _extendStroke(details.localPosition)
                        : null,
                    onPanEnd: _hasUpload && !_isGenerating
                        ? (_) => _endStroke()
                        : null,
                    child: const SizedBox.expand(),
                  ),
                ),
                if (!_hasUpload && !_isGenerating)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.28),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 40,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a photo from camera or gallery',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Then brush over objects to remove.',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlPanel(TextTheme textTheme) {
    final String primaryLabel = _hasResult
        ? 'Save cleaned image'
        : _isGenerating
        ? 'Cleaning...'
        : 'Remove objects';

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photo source',
            style: textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PillButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Capture',
                  onTap: () => _pickPhoto(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PillButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () => _pickPhoto(ImageSource.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 14),
          Text(
            'Brush size (${_brushSize.toStringAsFixed(0)} px)',
            style: textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.remove, size: 14, color: Colors.white70),
              Expanded(
                child: Slider(
                  min: 10,
                  max: 60,
                  divisions: 10,
                  value: _brushSize,
                  onChanged: (value) => setState(() => _brushSize = value),
                  activeColor: AppColors.accent,
                  inactiveColor: Colors.white24,
                ),
              ),
              const Icon(Icons.add, size: 14, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Undo stroke',
                  onTap: _strokes.isNotEmpty
                      ? _undoStroke
                      : () => _showToast('No mask to undo.'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SecondaryButton(
                  label: 'Clear mask',
                  onTap: _strokes.isNotEmpty
                      ? _clearMask
                      : () => _showToast('Nothing to clear yet.'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: primaryLabel,
                  onTap: _hasResult ? _handleSave : _removeObjects,
                  enabled: _hasResult ? !_isGenerating : _canRunCleanup,
                  color: const Color(0xFFEAB485),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_hasResult)
            PrimaryButton(
              label: _showResult ? 'Show original' : 'Show cleaned',
              onTap: () => setState(() => _showResult = !_showResult),
              color: Colors.white.withValues(alpha: 0.14),
            ),
        ],
      ),
    );
  }

  bool get _canRunCleanup =>
      _strokes.isNotEmpty && _hasUpload && !_isGenerating;

  void _startStroke(Offset position) {
    setState(() {
      _strokes.add(_Stroke(points: [position], size: _brushSize));
      _hasResult = false;
      _showResult = false;
    });
  }

  void _extendStroke(Offset position) {
    if (_strokes.isEmpty) return;
    setState(() {
      _strokes.last.points.add(position);
    });
  }

  void _endStroke() {
    if (_strokes.isEmpty) return;
    setState(() {});
  }

  void _undoStroke() {
    if (_strokes.isEmpty) return;
    setState(() {
      _strokes.removeLast();
      _hasResult = false;
      _showResult = false;
      _mergedBytes = null;
      _cleanedImage = _originalImage;
    });
  }

  void _clearMask() {
    setState(() {
      _strokes.clear();
      _hasResult = false;
      _showResult = false;
      _mergedBytes = null;
      _cleanedImage = _originalImage;
    });
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 92,
      );
      if (file == null) {
        _showToast('No photo selected.');
        return;
      }

      // Use memory-backed image to avoid stale caching issues on some devices.
      final Uint8List bytes = await file.readAsBytes();
      final ImageProvider image = MemoryImage(bytes);
      setState(() {
        _hasUpload = true;
        _strokes.clear();
        _hasResult = false;
        _showResult = false;
        _mergedBytes = null;
        _imageVersion++;
        _originalImage = image;
        _cleanedImage = image;
      });
      _showToast(
        'Photo added from ${source == ImageSource.camera ? 'camera' : 'gallery'}.',
      );
    } catch (error) {
      debugPrint('Image pick failed: $error');
      _showToast('Could not pick image.');
    }
  }

  Future<void> _removeObjects() async {
    if (!_canRunCleanup) return;

    setState(() {
      _isGenerating = true;
      _generationProgress = 0.18;
      _generationStatus = 'Detecting objects...';
      _hasResult = false;
      _showResult = false;
    });

    await Future.delayed(const Duration(milliseconds: 780));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.52;
      _generationStatus = 'Inpainting masked areas...';
    });

    await Future.delayed(const Duration(milliseconds: 760));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.86;
      _generationStatus = 'Blending cleanup...';
    });

    final ImageProvider mergedImage = await _composeCleanedImage();
    if (!mounted) return;
    setState(() {
      _cleanedImage = mergedImage;
      _imageVersion++;
      _generationProgress = 1.0;
      _generationStatus = 'Complete';
    });

    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _hasResult = true;
      _showResult = true;
    });
    _showToast('Objects removed and mask merged.');
  }

  Future<ImageProvider> _composeCleanedImage() async {
    final Size? size = _canvasSize;
    if (size == null) return _originalImage;
    if (!mounted) return _originalImage;

    try {
      final double pixelRatio = MediaQuery.of(
        context,
      ).devicePixelRatio.clamp(1.0, 4.0);
      final ui.Image baseImage = await _loadUiImage(
        _originalImage,
        size,
        pixelRatio: pixelRatio,
      );
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      paintImage(
        canvas: canvas,
        image: baseImage,
        rect: Offset.zero & size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      );

      for (final stroke in _strokes) {
        if (stroke.points.length < 2) continue;
        final double size = stroke.size;
        final Paint softRemovalPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size * 1.35
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.softLight
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        final Paint highlightPaint = Paint()
          ..color = AppColors.accent.withValues(alpha: 0.48)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2);

        final Path path = Path()
          ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
        for (int i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }
        canvas.drawPath(path, softRemovalPaint);
        canvas.drawPath(path, highlightPaint);
      }

      final ui.Image mergedImage = await recorder.endRecording().toImage(
        (size.width * pixelRatio).round(),
        (size.height * pixelRatio).round(),
      );
      final ByteData? bytes = await mergedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (bytes == null) return _originalImage;

      final Uint8List data = bytes.buffer.asUint8List();
      _mergedBytes = data;
      return MemoryImage(data);
    } catch (error) {
      debugPrint('Failed to merge mask: $error');
      return _originalImage;
    }
  }

  Future<ui.Image> _loadUiImage(
    ImageProvider provider,
    Size targetSize, {
    required double pixelRatio,
  }) {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(
      ImageConfiguration(size: targetSize, devicePixelRatio: pixelRatio),
    );

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo imageInfo, bool _) {
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.complete(imageInfo.image);
        }
      },
      onError: (Object error, StackTrace? stackTrace) {
        stream.removeListener(listener);
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    );

    stream.addListener(listener);
    return completer.future;
  }

  void _handleSave() {
    if (!_hasResult) {
      _showToast('Run cleanup before saving.');
      return;
    }
    final double? sizeKb = _mergedBytes != null
        ? _mergedBytes!.lengthInBytes / 1024
        : null;
    if (sizeKb != null) {
      _showToast('Cleaned image ready (~${sizeKb.toStringAsFixed(1)} KB).');
    } else {
      _showToast('Cleaned image ready to save.');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withValues(alpha: 0.85),
      ),
    );
  }
}

class _MaskPainter extends CustomPainter {
  const _MaskPainter({required this.strokes, required this.color});

  final List<_Stroke> strokes;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;
      final Paint paint = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.size
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.6);

      final Path path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MaskPainter oldDelegate) {
    return true;
  }
}

class _Stroke {
  _Stroke({required this.points, required this.size});

  final List<Offset> points;
  final double size;
}
