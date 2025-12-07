import 'package:ai_home_design/models/design_models.dart';
import 'package:ai_home_design/widgets/steps/price_list_step.dart';
import 'package:ai_home_design/widgets/steps/result_step.dart';
import 'package:ai_home_design/widgets/steps/review_step.dart';
import 'package:ai_home_design/widgets/steps/style_step.dart';
import 'package:ai_home_design/widgets/steps/upload_step.dart';
import 'package:ai_home_design/widgets/generating_overlay.dart';
import 'package:ai_home_design/widgets/top_nav_bar.dart';
import 'package:ai_home_design/widgets/app_buttons.dart';
import 'package:ai_home_design/widgets/full_screen_before_after.dart';
import 'package:ai_home_design/widgets/glass_panel.dart';
import 'package:flutter/material.dart';

class ExteriorDesignPage extends StatefulWidget {
  const ExteriorDesignPage({super.key});

  static const String backgroundImage = 'assets/images/bg_home.png';
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xF015191C), Color(0xD0121819), Color(0xCC0F231D)],
    stops: [0.0, 0.45, 1.0],
  );

  @override
  State<ExteriorDesignPage> createState() => _ExteriorDesignPageState();
}

class _ExteriorDesignPageState extends State<ExteriorDesignPage> {
  final PageController _pageController = PageController();
  final TextEditingController _promptController = TextEditingController();

  int _currentStep = 0;
  bool _hasUploaded = false;
  String? _selectedStyle;
  String _selectedRatio = '16:9';
  ImageProvider _previewImage = const NetworkImage(
    'https://picsum.photos/seed/exterior-preview/1200/900',
  );
  final ImageProvider _beforeImage = const NetworkImage(
    'https://picsum.photos/seed/exterior-before/1200/900',
  );
  final ImageProvider _afterImage = const NetworkImage(
    'https://picsum.photos/seed/exterior-after/1200/900',
  );
  double _reveal = 0.48;
  bool _isGenerating = false;
  double _generationProgress = 0.18;
  String _generationStatus = 'Queued (1/8)';
  bool _hasResultReady = false;

  final List<PriceSection> _priceSections = const [
    PriceSection(
      title: 'Landscaping & Outdoor',
      items: [
        PriceItem(
          brand: 'Home Depot',
          name: 'Evergreen Shrub Set',
          description: '6-pack landscaping shrubs',
          price: 320,
          imageUrl: 'https://picsum.photos/seed/shrub/300/200',
          actionLabel: 'View Product',
        ),
        PriceItem(
          brand: 'Trex',
          name: 'Composite Decking',
          description: '200 sq ft bundle',
          price: 1250,
          imageUrl: 'https://picsum.photos/seed/deck/300/200',
          actionLabel: 'View Product',
        ),
      ],
    ),
    PriceSection(
      title: 'Facade & Paint',
      items: [
        PriceItem(
          brand: 'Behr',
          name: 'Exterior Paint - Dove',
          description: '5 gallon',
          price: 240,
          imageUrl: 'https://picsum.photos/seed/paint-exterior/300/200',
          actionLabel: 'Copy Code',
        ),
        PriceItem(
          brand: 'James Hardie',
          name: 'Fiber Cement Panels',
          description: 'Modern vertical siding',
          price: 1850,
          imageUrl: 'https://picsum.photos/seed/siding/300/200',
          actionLabel: 'View Product',
        ),
      ],
    ),
    PriceSection(
      title: 'Lighting',
      items: [
        PriceItem(
          brand: 'Philips Hue',
          name: 'Outdoor Wall Lights',
          description: '2-pack, warm white',
          price: 320,
          imageUrl: 'https://picsum.photos/seed/outdoor-light/300/200',
          actionLabel: 'View Product',
        ),
      ],
    ),
  ];

  final List<StyleOption> _styles = const [
    StyleOption(
      title: 'Modern Minimalist',
      imageUrl: 'https://picsum.photos/seed/exterior-modern/1100/1400',
    ),
    StyleOption(
      title: 'Tropical Villa',
      imageUrl: 'https://picsum.photos/seed/exterior-tropical/1100/1400',
    ),
    StyleOption(
      title: 'Coastal Contemporary',
      imageUrl: 'https://picsum.photos/seed/exterior-coastal/1100/1400',
    ),
    StyleOption(
      title: 'Rustic Cabin',
      imageUrl: 'https://picsum.photos/seed/exterior-cabin/1100/1400',
    ),
    StyleOption(
      title: 'Mediterranean',
      imageUrl: 'https://picsum.photos/seed/exterior-mediterranean/1100/1400',
    ),
    StyleOption(
      title: 'Urban Townhouse',
      imageUrl: 'https://picsum.photos/seed/exterior-townhouse/1100/1400',
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
      _showToast('Upload an exterior photo first.');
      return;
    }
    if (index >= 2 && _selectedStyle == null) {
      _showToast('Select a facade style first.');
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
        _showToast('Upload a facade photo to continue.');
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
      _previewImage = const NetworkImage(
        'https://picsum.photos/seed/exterior-upload/1200/900',
      );
    });
    _showToast('Facade photo added from $source.');
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
                            child: FullscreenBeforeAfter(
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
      _generationProgress = 0.22;
      _generationStatus = 'Queued (1/8)';
      _hasResultReady = false;
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.58;
      _generationStatus = 'Analyzing facade...';
    });

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _generationProgress = 1.0;
      _generationStatus = 'Rendering new look...';
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
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _generationProgress = 0.52;
      _generationStatus = 'Sourcing materials...';
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
              ExteriorDesignPage.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: ExteriorDesignPage.backgroundGradient,
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
                            'Exterior AI Designer',
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
                            title: 'Upload Exterior Photo',
                            subtitle:
                                'Upload a clear photo of your home facade to start the redesign.',
                            emptyLabel: 'Add exterior photo',
                            readyLabel: 'Exterior photo ready',
                            photoTips: const [
                              PhotoTip(
                                icon: Icons.wb_sunny_outlined,
                                text:
                                    'Shoot during soft daylight to avoid harsh shadows.',
                              ),
                              PhotoTip(
                                icon: Icons.crop_landscape,
                                text:
                                    'Capture the full facade, landscaping, and driveway.',
                              ),
                              PhotoTip(
                                icon: Icons.straighten,
                                text:
                                    'Hold the camera straight-on to avoid distortion.',
                              ),
                            ],
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
            ),
        ],
      ),
    );
  }
}
