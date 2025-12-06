import 'package:ai_home_design/page/interior_design/widgets/photo_preview.dart';
import 'package:ai_home_design/page/interior_design/widgets/step_header.dart';
import 'package:flutter/material.dart';

class UploadStep extends StatelessWidget {
  const UploadStep({
    required this.textTheme,
    required this.previewImage,
    required this.hasUpload,
    required this.onCapture,
    required this.onGallery,
    super.key,
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
        StepHeader(
          textTheme: textTheme,
          title: 'Upload Room Photo',
          subtitle:
              'Upload a photo of your room to get started with our AI designer.',
        ),
        const SizedBox(height: 18),
        PhotoPreview(
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
                TipItem(
                  icon: Icons.lightbulb_outline,
                  text: 'Use good, natural lighting.',
                ),
                SizedBox(height: 10),
                TipItem(
                  icon: Icons.fullscreen,
                  text: 'Capture as much of the room as possible.',
                ),
                SizedBox(height: 10),
                TipItem(
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
