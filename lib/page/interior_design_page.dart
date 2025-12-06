import 'dart:ui';

import 'package:flutter/material.dart';

class InteriorDesignPage extends StatefulWidget {
  const InteriorDesignPage({super.key});

  static const Color _accent = Color(0xFF24C081);

  @override
  State<InteriorDesignPage> createState() => _InteriorDesignPageState();
}

class _InteriorDesignPageState extends State<InteriorDesignPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _hasUploaded = false;
  String? _selectedStyle;
  String _selectedRatio = '1:1';
  final TextEditingController _promptController = TextEditingController();
  ImageProvider _previewImage = const AssetImage('assets/images/bg_home.png');

  final List<_StyleOption> _styles = const [
    _StyleOption(
      title: 'Scandinavian',
      imageUrl: 'https://picsum.photos/seed/scandinavian/900/1200',
    ),
    _StyleOption(
      title: 'Japandi',
      imageUrl: 'https://picsum.photos/seed/japandi/900/1200',
    ),
    _StyleOption(
      title: 'Luxury Hotel',
      imageUrl: 'https://picsum.photos/seed/luxuryhotel/900/1200',
    ),
    _StyleOption(
      title: 'Minimalist',
      imageUrl: 'https://picsum.photos/seed/minimalist/900/1200',
    ),
    _StyleOption(
      title: 'Modern Industrial',
      imageUrl: 'https://picsum.photos/seed/industrial/900/1200',
    ),
    _StyleOption(
      title: "Kid's Bedroom Themes",
      imageUrl: 'https://picsum.photos/seed/kids/900/1200',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _handleNavTap(int index) {
    if (index == 1 && !_hasUploaded) {
      _showToast('Upload a room photo first.');
      return;
    }
    if (index == 2 && !_hasUploaded) {
      _showToast('Upload a room photo first.');
      return;
    }
    if (index == 2 && _selectedStyle == null) {
      _showToast('Select a design style first.');
      return;
    }
    if (index <= 2) {
      _goToStep(index);
    } else {
      _showToast('This step is coming soon.');
    }
  }

  void _handleBack() {
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

    _showToast('Ready to generate with $_selectedStyle ($_selectedRatio).');
  }

  void _goToStep(int index) {
    setState(() {
      _currentStep = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
    );
  }

  void _simulateUpload(String source) {
    setState(() {
      _hasUploaded = true;
      _previewImage = const AssetImage('assets/images/bg_home.png');
    });
    _showToast('Room photo added from $source.');
  }

  void _selectStyle(_StyleOption option) {
    setState(() {
      _selectedStyle = option.title;
    });
  }

  void _selectRatio(String ratio) {
    setState(() {
      _selectedRatio = ratio;
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.85),
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
            child: Image.asset('assets/images/bg_home.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xF015191C),
                    Color(0xD0121819),
                    Color(0xCC0F231D),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
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
                      const _RoundIconButton(icon: Icons.more_horiz),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _TopNavBar(
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
                        _GlassPanel(
                          child: _UploadStep(
                            textTheme: textTheme,
                            previewImage: _previewImage,
                            hasUpload: _hasUploaded,
                            onCapture: () => _simulateUpload('camera'),
                            onGallery: () => _simulateUpload('gallery'),
                          ),
                        ),
                        _GlassPanel(
                          child: _StyleStep(
                            textTheme: textTheme,
                            styles: _styles,
                            selectedStyle: _selectedStyle,
                            onSelect: _selectStyle,
                          ),
                        ),
                        _GlassPanel(
                          child: _ReviewStep(
                            textTheme: textTheme,
                            previewImage: _previewImage,
                            selectedStyle: _selectedStyle,
                            selectedRatio: _selectedRatio,
                            onRatioSelect: _selectRatio,
                            promptController: _promptController,
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
                        child: _SecondaryButton(
                          label: 'Back',
                          onTap: _handleBack,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PrimaryButton(
                          label: _currentStep == 0
                              ? 'Next'
                              : _currentStep == 1
                                  ? 'Next'
                                  : 'Generate',
                          onTap: _handleNext,
                          enabled: _currentStep == 0
                              ? _hasUploaded
                              : _currentStep == 1
                                  ? _selectedStyle != null
                                  : _selectedStyle != null && _hasUploaded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _UploadStep extends StatelessWidget {
  const _UploadStep({
    required this.textTheme,
    required this.previewImage,
    required this.hasUpload,
    required this.onCapture,
    required this.onGallery,
  });

  final TextTheme textTheme;
  final ImageProvider previewImage;
  final bool hasUpload;
  final VoidCallback onCapture;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Room Photo',
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Upload a photo of your room to get started with our AI designer.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            height: 1.35,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 18),
        _PhotoPreview(
          image: previewImage,
          hasUpload: hasUpload,
          onCapture: onCapture,
          onGallery: onGallery,
        ),
        const SizedBox(height: 20),
        Text(
          'Photo Tips',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                _TipItem(
                  icon: Icons.lightbulb_outline,
                  text: 'Use good, natural lighting.',
                ),
                SizedBox(height: 10),
                _TipItem(
                  icon: Icons.fullscreen,
                  text: 'Capture as much of the room as possible.',
                ),
                SizedBox(height: 10),
                _TipItem(
                  icon: Icons.inventory_2_outlined,
                  text: 'Include furniture for context.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StyleStep extends StatelessWidget {
  const _StyleStep({
    required this.textTheme,
    required this.styles,
    required this.selectedStyle,
    required this.onSelect,
  });

  final TextTheme textTheme;
  final List<_StyleOption> styles;
  final String? selectedStyle;
  final ValueChanged<_StyleOption> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Design Style',
          style: textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose the aesthetic for your new space.',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
            height: 1.35,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: GridView.builder(
            itemCount: styles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final option = styles[index];
              final bool isSelected = option.title == selectedStyle;
              return _StyleCard(
                option: option,
                selected: isSelected,
                onTap: () => onSelect(option),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.textTheme,
    required this.previewImage,
    required this.selectedStyle,
    required this.selectedRatio,
    required this.onRatioSelect,
    required this.promptController,
  });

  final TextTheme textTheme;
  final ImageProvider previewImage;
  final String? selectedStyle;
  final String selectedRatio;
  final ValueChanged<String> onRatioSelect;
  final TextEditingController promptController;

  @override
  Widget build(BuildContext context) {
    const ratios = ['1:1', '4:5', '3:4', '9:16', '16:9'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Design',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Confirm your selections before generating the design.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: previewImage,
                        fit: BoxFit.cover,
                      ),
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
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.photo_camera_back_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Uploaded Room',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: InteriorDesignPage._accent.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: InteriorDesignPage._accent.withOpacity(0.6),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.style_outlined,
                        size: 16,
                        color: InteriorDesignPage._accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedStyle ?? 'No style selected',
                        style: TextStyle(
                          color: selectedStyle != null
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.aspect_ratio,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedRatio,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Image Ratio',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ratios
                .map(
                  (ratio) => _RatioChip(
                    label: ratio,
                    selected: ratio == selectedRatio,
                    onTap: () => onRatioSelect(ratio),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Notes / Prompt',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: promptController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText:
                    'Add room details or inspiration notes for the AI...',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'These notes will be added to the AI prompt for finer control.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _StyleOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(option.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.18),
                          BlendMode.darken,
                        ),
                      ),
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
                          Colors.black.withOpacity(0.08),
                          Colors.black.withOpacity(0.38),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: selected ? 1 : 0.75,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? InteriorDesignPage._accent
                              : Colors.white.withOpacity(0.2),
                          width: 1.4,
                        ),
                      ),
                      child: Icon(
                        selected ? Icons.check : Icons.palette_outlined,
                        size: 16,
                        color: selected
                            ? InteriorDesignPage._accent
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.brightness_1,
                          size: 12,
                          color: InteriorDesignPage._accent,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RatioChip extends StatelessWidget {
  const _RatioChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? InteriorDesignPage._accent.withOpacity(0.18)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? InteriorDesignPage._accent.withOpacity(0.8)
                : Colors.white.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.aspect_ratio,
              size: 14,
              color: selected
                  ? InteriorDesignPage._accent
                  : Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? InteriorDesignPage._accent
                    : Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  const _TopNavBar({required this.selectedIndex, required this.onItemSelected});

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.chair_alt_outlined, label: 'Room'),
      _NavItem(icon: Icons.style_outlined, label: 'Style'),
      _NavItem(icon: Icons.reviews_outlined, label: 'Review'),
      _NavItem(icon: Icons.workspace_premium_outlined, label: 'Result'),
      _NavItem(icon: Icons.list_alt_outlined, label: 'Price List'),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.32),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final bool isSelected = index == selectedIndex;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => onItemSelected(index),
                      splashColor: Colors.white.withOpacity(0.06),
                      highlightColor: Colors.white.withOpacity(0.04),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? InteriorDesignPage._accent.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                          border: isSelected
                              ? Border.all(
                                  color: InteriorDesignPage._accent.withOpacity(
                                    0.6,
                                  ),
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isSelected
                                  ? InteriorDesignPage._accent
                                  : Colors.white70,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? InteriorDesignPage._accent
                                    : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.image,
    required this.hasUpload,
    required this.onCapture,
    required this.onGallery,
  });

  final ImageProvider image;
  final bool hasUpload;
  final VoidCallback onCapture;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.45),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasUpload
                      ? InteriorDesignPage._accent.withOpacity(0.7)
                      : Colors.white.withOpacity(0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasUpload ? Icons.check_circle : Icons.info_outline,
                    size: 14,
                    color: hasUpload
                        ? InteriorDesignPage._accent
                        : Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasUpload ? 'Photo ready' : 'Add room photo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: Row(
              children: [
                Expanded(
                  child: _PillButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Capture',
                    onTap: onCapture,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PillButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: onGallery,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.16),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.12),
        highlightColor: Colors.white.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            splashColor: Colors.white.withOpacity(0.12),
            highlightColor: Colors.white.withOpacity(0.08),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: radius,
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color background = enabled
        ? InteriorDesignPage._accent
        : Colors.white.withOpacity(0.12);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: enabled ? onTap : null,
        splashColor: enabled
            ? Colors.white.withOpacity(0.1)
            : Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: enabled ? Colors.white : Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(28);
    return Material(
      color: Colors.white.withOpacity(0.08),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap ?? () {},
        splashColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _StyleOption {
  const _StyleOption({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
