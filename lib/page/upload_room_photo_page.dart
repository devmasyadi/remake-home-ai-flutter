import 'dart:ui';

import 'package:flutter/material.dart';

class UploadRoomPhotoPage extends StatelessWidget {
  const UploadRoomPhotoPage({super.key});

  static const Color _accent = Color(0xFF24C081);

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
                  const _TopNavBar(selectedIndex: 0),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GlassPanel(
                            child: Column(
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
                                const _PhotoPreview(),
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
                                const _TipItem(
                                  icon: Icons.lightbulb_outline,
                                  text: 'Use good, natural lighting.',
                                ),
                                const SizedBox(height: 10),
                                const _TipItem(
                                  icon: Icons.fullscreen,
                                  text:
                                      'Capture as much of the room as possible.',
                                ),
                                const SizedBox(height: 10),
                                const _TipItem(
                                  icon: Icons.inventory_2_outlined,
                                  text: 'Include furniture for context.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _PrimaryButton(label: 'Next', onTap: () {}),
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

class _TopNavBar extends StatelessWidget {
  const _TopNavBar({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(icon: Icons.chair_alt_outlined, label: 'Room'),
      _NavItem(icon: Icons.style_outlined, label: 'Style'),
      _NavItem(icon: Icons.reviews_outlined, label: 'Review'),
      _NavItem(icon: Icons.workspace_premium_outlined, label: 'Result'),
      _NavItem(icon: Icons.list_alt_outlined, label: 'Shopping List'),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      onTap: () {},
                      splashColor: Colors.white.withOpacity(0.06),
                      highlightColor: Colors.white.withOpacity(0.04),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? UploadRoomPhotoPage._accent.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                          border: isSelected
                              ? Border.all(
                                  color: UploadRoomPhotoPage._accent
                                      .withOpacity(0.6),
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
                                  ? UploadRoomPhotoPage._accent
                                  : Colors.white70,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? UploadRoomPhotoPage._accent
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
  const _PhotoPreview();

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
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                ),
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
            left: 14,
            right: 14,
            bottom: 12,
            child: Row(
              children: const [
                Expanded(
                  child: _PillButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Capture',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _PillButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
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
  const _PillButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.16),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
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
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: UploadRoomPhotoPage._accent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.1),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
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

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
