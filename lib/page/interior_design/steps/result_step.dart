import 'package:ai_home_design/page/interior_design/widgets/step_header.dart';
import 'package:ai_home_design/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class ResultStep extends StatelessWidget {
  const ResultStep({
    required this.textTheme,
    required this.beforeImage,
    required this.afterImage,
    required this.reveal,
    required this.onRevealChanged,
    required this.onShareResult,
    required this.onSave,
    required this.onFullscreen,
    required this.onRegenerate,
    super.key,
  });

  final TextTheme textTheme;
  final ImageProvider beforeImage;
  final ImageProvider afterImage;
  final double reveal;
  final ValueChanged<double> onRevealChanged;
  final VoidCallback onShareResult;
  final VoidCallback onSave;
  final VoidCallback onFullscreen;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          textTheme: textTheme,
          title: 'AI Redesign Result',
          subtitle: 'Preview your generated design and refine if needed.',
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: beforeImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double clampedReveal =
                          reveal.clamp(0.0, 1.0).toDouble();
                      final double handleX =
                          (constraints.maxWidth * clampedReveal)
                              .clamp(0.0, constraints.maxWidth)
                              .toDouble();

                      void updateReveal(Offset position) {
                        final dx = position.dx.clamp(
                          0.0,
                          constraints.maxWidth,
                        );
                        onRevealChanged(dx / constraints.maxWidth);
                      }

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapDown: (details) =>
                            updateReveal(details.localPosition),
                        onHorizontalDragStart: (details) =>
                            updateReveal(details.localPosition),
                        onHorizontalDragUpdate: (details) =>
                            updateReveal(details.localPosition),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRect(
                                clipper: _RevealClipper(handleX),
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
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            Positioned(
                              left: handleX - 18,
                              top: constraints.maxHeight / 2 - 18,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.swap_horiz,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 10,
                              top: 10,
                              child: ResultBadge(label: 'Before'),
                            ),
                            const Positioned(
                              right: 10,
                              top: 10,
                              child: ResultBadge(label: 'After'),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: IconPill(
                                icon: Icons.zoom_out_map,
                                onTap: onFullscreen,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 56,
                              child: IconPill(
                                icon: Icons.refresh,
                                onTap: onRegenerate,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ActionPill(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: onShareResult,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionPill(
                icon: Icons.download_outlined,
                label: 'Save Design',
                onTap: onSave,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ResultBadge extends StatelessWidget {
  const ResultBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _RevealClipper extends CustomClipper<Rect> {
  const _RevealClipper(this.handleX);

  final double handleX;

  @override
  Rect getClip(Size size) {
    final x = handleX.clamp(0.0, size.width);
    return Rect.fromLTRB(x, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant _RevealClipper oldClipper) =>
      oldClipper.handleX != handleX;
}
