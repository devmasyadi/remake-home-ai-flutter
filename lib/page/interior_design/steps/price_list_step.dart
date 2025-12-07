import 'package:ai_home_design/page/interior_design/models/design_models.dart';
import 'package:flutter/material.dart';

class PriceListStep extends StatelessWidget {
  const PriceListStep({
    required this.textTheme,
    required this.sections,
    super.key,
  });

  final TextTheme textTheme;
  final List<PriceSection> sections;

  @override
  Widget build(BuildContext context) {
    final double total = sections
        .expand((s) => s.items)
        .fold(0.0, (sum, item) => sum + item.price);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage(
                                'assets/images/bg_home.png',
                              ),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.35),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Total Estimated Cost:',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'For your personalized redesign',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  sections.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == sections.length - 1 ? 16 : 14,
                    ),
                    child: PriceSectionCard(section: sections[index]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PriceSectionCard extends StatelessWidget {
  const PriceSectionCard({required this.section, super.key});

  final PriceSection section;

  @override
  Widget build(BuildContext context) {
    return _ExpandablePriceSection(section: section);
  }
}

class PriceItemCard extends StatelessWidget {
  const PriceItemCard({required this.item, super.key});

  final PriceItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.brand,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.description}. Est. Price: \$${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ExpandablePriceSection extends StatefulWidget {
  const _ExpandablePriceSection({required this.section});

  final PriceSection section;

  @override
  State<_ExpandablePriceSection> createState() =>
      _ExpandablePriceSectionState();
}

class _ExpandablePriceSectionState extends State<_ExpandablePriceSection>
    with TickerProviderStateMixin {
  bool _expanded = true;

  void _toggle() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.section.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _toggle,
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(
                    children: widget.section.items
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 2),
                            child: PriceItemCard(item: item),
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
