import 'package:ai_home_design/widgets/photo_preview.dart';
import 'package:ai_home_design/widgets/step_header.dart';
import 'package:flutter/material.dart';

class UploadStep extends StatelessWidget {
  const UploadStep({
    required this.textTheme,
    required this.previewImage,
    required this.hasUpload,
    required this.onCapture,
    required this.onGallery,
    this.title = 'Upload Room Photo',
    this.subtitle =
        'Upload a photo of your room to get started with our AI designer.',
    this.photoTips = const [
      PhotoTip(
        icon: Icons.lightbulb_outline,
        text: 'Use good, natural lighting.',
      ),
      PhotoTip(
        icon: Icons.fullscreen,
        text: 'Capture as much of the room as possible.',
      ),
      PhotoTip(
        icon: Icons.inventory_2_outlined,
        text: 'Include furniture for context.',
      ),
    ],
    this.emptyLabel = 'Add room photo',
    this.readyLabel = 'Photo ready',
    super.key,
  });

  final TextTheme textTheme;
  final ImageProvider previewImage;
  final bool hasUpload;
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final String title;
  final String subtitle;
  final List<PhotoTip> photoTips;
  final String emptyLabel;
  final String readyLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(textTheme: textTheme, title: title, subtitle: subtitle),
        const SizedBox(height: 18),
        PhotoPreview(
          image: previewImage,
          hasUpload: hasUpload,
          onCapture: onCapture,
          onGallery: onGallery,
          emptyLabel: emptyLabel,
          readyLabel: readyLabel,
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
              children: List.generate(photoTips.length, (index) {
                final tip = photoTips[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == photoTips.length - 1 ? 0 : 10,
                  ),
                  child: TipItem(icon: tip.icon, text: tip.text),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoTip {
  const PhotoTip({required this.icon, required this.text});

  final IconData icon;
  final String text;
}
