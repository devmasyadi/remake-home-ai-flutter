import 'package:ai_home_design/theme/app_colors.dart';
import 'package:ai_home_design/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    required this.image,
    required this.hasUpload,
    required this.onCapture,
    required this.onGallery,
    super.key,
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.cover),
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
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.45),
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
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasUpload
                      ? AppColors.accent.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasUpload ? Icons.check_circle : Icons.info_outline,
                    size: 14,
                    color: hasUpload ? AppColors.accent : Colors.white70,
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
                  child: PillButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Capture',
                    onTap: onCapture,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PillButton(
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

class TipItem extends StatelessWidget {
  const TipItem({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
