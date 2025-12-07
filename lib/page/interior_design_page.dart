import 'package:ai_home_design/models/design_models.dart';
import 'package:ai_home_design/widgets/steps/price_list_step.dart';
import 'package:ai_home_design/widgets/steps/result_step.dart';
import 'package:ai_home_design/widgets/steps/review_step.dart';
import 'package:ai_home_design/widgets/steps/style_step.dart';
import 'package:ai_home_design/widgets/steps/upload_step.dart';
import 'package:ai_home_design/widgets/generating_overlay.dart';
import 'package:ai_home_design/widgets/top_nav_bar.dart';
import 'package:ai_home_design/widgets/app_buttons.dart';
import 'package:ai_home_design/widgets/glass_panel.dart';
import 'package:flutter/material.dart';

class InteriorDesignPage extends StatefulWidget {
  const InteriorDesignPage({super.key});

  static const String backgroundImage = 'assets/images/bg_home.png';
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xF015191C), Color(0xD0121819), Color(0xCC0F231D)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  State<InteriorDesignPage> createState() => _InteriorDesignPageState();
}

class _InteriorDesignPageState extends State<InteriorDesignPage> {
  final PageController _pageController = PageController();
  final TextEditingController _promptController = TextEditingController();

  int _currentStep = 0;
  bool _hasUploaded = false;
  String? _selectedStyle;
  String _selectedRatio = '1:1';
  ImageProvider _previewImage = const AssetImage(
    InteriorDesignPage.backgroundImage,
  );
  final ImageProvider _beforeImage = const NetworkImage(
    'https://picsum.photos/seed/before/900/1200',
  );
  final ImageProvider _afterImage = const NetworkImage(
    'https://picsum.photos/seed/after/900/1200',
  );
  double _reveal = 0.52;
  bool _isGenerating = false;
  double _generationProgress = 0.2;
  String _generationTitle = 'Generating your design...';
  String _generationStatus = 'Queued (2/10)';
  bool _hasResultReady = false;

  final List<PriceSection> _priceSections = const [
    PriceSection(
      title: 'Furniture',
      items: [
        PriceItem(
          brand: 'IKEA',
          name: 'Ektorp Sofa',
          description: '3-seat, beige',
          price: 799,
          imageUrl: 'https://picsum.photos/seed/sofa/300/200',
          actionLabel: 'View Product',
        ),
        PriceItem(
          brand: 'Wayfair',
          name: 'Walnut Coffee Table',
          description: 'Solid wood',
          price: 350,
          imageUrl: 'https://picsum.photos/seed/table/300/200',
          actionLabel: 'View Product',
        ),
      ],
    ),
    PriceSection(
      title: 'Lighting',
      items: [
        PriceItem(
          brand: 'Philips Hue',
          name: 'Smart Floor Lamp',
          description: 'Warm white',
          price: 220,
          imageUrl: 'https://picsum.photos/seed/lamp/300/200',
          actionLabel: 'View Product',
        ),
      ],
    ),
    PriceSection(
      title: 'Paint',
      items: [
        PriceItem(
          brand: 'Benjamin Moore',
          name: 'Chantilly Lace',
          description: 'OC-65',
          price: 65,
          imageUrl: 'https://picsum.photos/seed/paint/300/200',
          actionLabel: 'Copy Code',
        ),
      ],
    ),
  ];

  final List<StyleOption> _styles = const [
    StyleOption(
      title: 'Scandinavian',
      imageUrl: 'https://picsum.photos/seed/scandinavian/900/1200',
    ),
    StyleOption(
      title: 'Japandi',
      imageUrl: 'https://picsum.photos/seed/japandi/900/1200',
    ),
    StyleOption(
      title: 'Luxury Hotel',
      imageUrl: 'https://picsum.photos/seed/luxuryhotel/900/1200',
    ),
    StyleOption(
      title: 'Minimalist',
      imageUrl: 'https://picsum.photos/seed/minimalist/900/1200',
    ),
    StyleOption(
      title: 'Modern Industrial',
      imageUrl: 'https://picsum.photos/seed/industrial/900/1200',
    ),
    StyleOption(
      title: "Kid's Bedroom Themes",
      imageUrl: 'https://picsum.photos/seed/kids/900/1200',
    ),
  ];

  String get _primaryLabel {
    switch (_currentStep) {
      case 0:
      case 1:
        return 'Next';
      case 2:
        return _isGenerating ? 'Generating...' : 'Generate';
      case 3:
        return 'Get Price List';
      default:
        return 'Save List';
    }
  }

  bool get _primaryEnabled {
    switch (_currentStep) {
      case 0:
        return _hasUploaded;
      case 1:
        return _selectedStyle != null;
      case 2:
        return _selectedStyle != null && _hasUploaded && !_isGenerating;
      case 3:
        return _hasResultReady && !_isGenerating;
      default:
        return !_isGenerating;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _handleNavTap(int index) {
    if (_isGenerating) return;
    if (index >= 1 && !_hasUploaded) {
      _showToast('Upload a room photo first.');
      return;
    }
    if (index >= 2 && _selectedStyle == null) {
      _showToast('Select a design style first.');
      return;
    }
    if (index >= 3 && !_hasResultReady) {
      _showToast('Generate a result first.');
      return;
    }
    if (index <= 4) {
      _goToStep(index);
    } else {
      _showToast('This step is coming soon.');
    }
  }

  void _handleBack() {
    if (_isGenerating) return;
    if (_currentStep == 0) {
      Navigator.pop(context);
    } else {
      _goToStep(_currentStep - 1);
    }
  }

  void _handleNext() {
    if (_currentStep == 0) {
      if (!_hasUploaded) {
        _showToast('Upload a room photo to continue.');
        return;
      }
      _goToStep(1);
      return;
    }

    if (_currentStep == 1) {
      if (_selectedStyle == null) {
        _showToast('Choose a style to continue.');
        return;
      }
      _goToStep(2);
      return;
    }

    if (_currentStep == 2) {
      if (_isGenerating) return;
      _startGeneration();
      return;
    }

    if (_currentStep == 3) {
      if (_isGenerating) return;
      _startPriceList();
      return;
    }

    _showToast('Price list saved.');
  }

  void _goToStep(int index) {
    setState(() => _currentStep = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
    );
  }

  void _simulateUpload(String source) {
    setState(() {
      _hasUploaded = true;
      _previewImage = const AssetImage(InteriorDesignPage.backgroundImage);
    });
    _showToast('Room photo added from $source.');
  }

  void _selectStyle(StyleOption option) {
    setState(() => _selectedStyle = option.title);
  }

  void _selectRatio(String ratio) {
    setState(() => _selectedRatio = ratio);
  }

  void _updateReveal(double value) {
    setState(() {
      _reveal = value.clamp(0.05, 0.95);
    });
  }

  Future<void> _openFullscreenPreview() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close preview',
      barrierColor: Colors.black.withValues(alpha: 0.82),
      pageBuilder: (context, animation, secondaryAnimation) {
        double localReveal = _reveal;

        return StatefulBuilder(
          builder: (context, dialogSetState) {
            void update(double value) {
              final adjusted = value.clamp(0.05, 0.95);
              dialogSetState(() => localReveal = adjusted);
              _updateReveal(adjusted);
            }

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 1100,
                            maxHeight: 900,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: _FullscreenBeforeAfter(
                              beforeImage: _beforeImage,
                              afterImage: _afterImage,
                              reveal: localReveal,
                              onRevealChanged: update,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          splashRadius: 22,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _startGeneration() async {
    setState(() {
      _isGenerating = true;
      _generationProgress = 0.2;
      _generationStatus = 'Queued (2/10)';
      _generationTitle = 'Generating your design...';
      _hasResultReady = false;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.55;
      _generationStatus = 'Processing design...';
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _generationProgress = 1.0;
      _generationStatus = 'Complete';
    });

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _hasResultReady = true;
    });
    _goToStep(3);
    _showToast('Design ready!');
  }

  Future<void> _startPriceList() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
      _generationProgress = 0.18;
      _generationStatus = 'Queued (price list)';
      _generationTitle = 'Generating price list...';
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.52;
      _generationStatus = 'Gathering products...';
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.86;
      _generationStatus = 'Formatting list...';
    });

    await Future.delayed(const Duration(milliseconds: 480));
    if (!mounted) return;
    setState(() {
      _generationProgress = 1.0;
      _generationStatus = 'Price list ready';
    });

    await Future.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
    });
    _goToStep(4);
    _showToast('Price list ready!');
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              InteriorDesignPage.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: InteriorDesignPage.backgroundGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RemakeHome',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Interior AI Designer',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const RoundIconButton(icon: Icons.more_horiz),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TopNavBar(
                    selectedIndex: _currentStep,
                    onItemSelected: _handleNavTap,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentStep = index;
                        });
                      },
                      children: [
                        GlassPanel(
                          child: UploadStep(
                            textTheme: textTheme,
                            previewImage: _previewImage,
                            hasUpload: _hasUploaded,
                            onCapture: () => _simulateUpload('camera'),
                            onGallery: () => _simulateUpload('gallery'),
                          ),
                        ),
                        GlassPanel(
                          child: StyleStep(
                            textTheme: textTheme,
                            styles: _styles,
                            selectedStyle: _selectedStyle,
                            onSelect: _selectStyle,
                          ),
                        ),
                        GlassPanel(
                          child: ReviewStep(
                            textTheme: textTheme,
                            previewImage: _previewImage,
                            selectedStyle: _selectedStyle,
                            selectedRatio: _selectedRatio,
                            onRatioSelect: _selectRatio,
                            promptController: _promptController,
                          ),
                        ),
                        GlassPanel(
                          child: ResultStep(
                            textTheme: textTheme,
                            beforeImage: _beforeImage,
                            afterImage: _afterImage,
                            reveal: _reveal,
                            onRevealChanged: _updateReveal,
                            onShareResult: () =>
                                _showToast('Sharing design...'),
                            onSave: () =>
                                _showToast('Design saved to gallery.'),
                            onFullscreen: _openFullscreenPreview,
                            onRegenerate: () =>
                                _showToast('Regenerating design...'),
                          ),
                        ),
                        GlassPanel(
                          child: PriceListStep(
                            textTheme: textTheme,
                            sections: _priceSections,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: SecondaryButton(
                          label: 'Back',
                          onTap: _handleBack,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: _primaryLabel,
                          onTap: _handleNext,
                          enabled: _primaryEnabled,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (_isGenerating)
            GeneratingOverlay(
              status: _generationStatus,
              progress: _generationProgress,
              title: _generationTitle,
            ),
        ],
      ),
    );
  }
}

class _FullscreenBeforeAfter extends StatelessWidget {
  const _FullscreenBeforeAfter({
    required this.beforeImage,
    required this.afterImage,
    required this.reveal,
    required this.onRevealChanged,
  });

  final ImageProvider beforeImage;
  final ImageProvider afterImage;
  final double reveal;
  final ValueChanged<double> onRevealChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(image: beforeImage, fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double clampedReveal = reveal.clamp(0.0, 1.0).toDouble();
              final double handleX = (constraints.maxWidth * clampedReveal)
                  .clamp(0.0, constraints.maxWidth);

              void updateReveal(Offset position) {
                final dx = position.dx.clamp(0.0, constraints.maxWidth);
                onRevealChanged(dx / constraints.maxWidth);
              }

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (details) => updateReveal(details.localPosition),
                onHorizontalDragStart: (details) =>
                    updateReveal(details.localPosition),
                onHorizontalDragUpdate: (details) =>
                    updateReveal(details.localPosition),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRect(
                        clipper: RevealClipper(handleX),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: afterImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: handleX - 1,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    Positioned(
                      left: handleX - 22,
                      top: constraints.maxHeight / 2 - 22,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.32),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.swap_horiz,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 12,
                      top: 12,
                      child: ResultBadge(label: 'Before'),
                    ),
                    const Positioned(
                      right: 12,
                      top: 12,
                      child: ResultBadge(label: 'After'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
