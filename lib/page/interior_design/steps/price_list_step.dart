import 'package:ai_home_design/page/interior_design/models/design_models.dart';
import 'package:ai_home_design/widgets/app_buttons.dart';
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

    return Column(
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
                      image: const AssetImage('assets/images/bg_home.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35),
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
        Expanded(
          child: ListView.separated(
            itemCount: sections.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              if (index == sections.length) {
                return PrimaryButton(
                  label: 'Save List',
                  onTap: () {},
                  enabled: true,
                );
              }
              final section = sections[index];
              return PriceSectionCard(section: section);
            },
          ),
        ),
      ],
    );
  }
}

class PriceSectionCard extends StatelessWidget {
  const PriceSectionCard({required this.section, super.key});

  final PriceSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                section.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: section.items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PriceItemCard(item: item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
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
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
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
                const SizedBox(height: 8),
                ActionPill(
                  icon: item.actionLabel == 'Copy Code'
                      ? Icons.copy
                      : Icons.shopping_bag_outlined,
                  label: item.actionLabel,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 90,
              height: 90,
              color: Colors.white,
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
