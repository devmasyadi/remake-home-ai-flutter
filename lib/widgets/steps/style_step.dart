import 'package:ai_home_design/models/design_models.dart';
import 'package:ai_home_design/widgets/step_header.dart';
import 'package:ai_home_design/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StyleStep extends StatelessWidget {
  const StyleStep({
    required this.textTheme,
    required this.styles,
    required this.selectedStyle,
    required this.onSelect,
    super.key,
  });

  final TextTheme textTheme;
  final List<StyleOption> styles;
  final String? selectedStyle;
  final ValueChanged<StyleOption> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepHeader(
          textTheme: textTheme,
          title: 'Select Design Style',
          subtitle: 'Choose the aesthetic for your new space.',
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
              return StyleCard(
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

class StyleCard extends StatelessWidget {
  const StyleCard({
    required this.option,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final StyleOption option;
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
          splashColor: Colors.white.withValues(alpha: 0.08),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
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
                          Colors.black.withValues(alpha: 0.18),
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
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.38),
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
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? AppColors.accent
                              : Colors.white.withValues(alpha: 0.2),
                          width: 1.4,
                        ),
                      ),
                      child: Icon(
                        selected ? Icons.check : Icons.palette_outlined,
                        size: 16,
                        color: selected ? AppColors.accent : Colors.white,
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
                        const Icon(
                          Icons.brightness_1,
                          size: 12,
                          color: AppColors.accent,
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
