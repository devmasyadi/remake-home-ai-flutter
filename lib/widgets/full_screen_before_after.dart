import 'package:ai_home_design/widgets/steps/result_step.dart';
import 'package:flutter/material.dart';

class FullscreenBeforeAfter extends StatelessWidget {
  const FullscreenBeforeAfter({
    super.key,
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
