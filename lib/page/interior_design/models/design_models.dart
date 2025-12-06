class StyleOption {
  const StyleOption({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;
}

class PriceSection {
  const PriceSection({required this.title, required this.items});

  final String title;
  final List<PriceItem> items;
}

class PriceItem {
  const PriceItem({
    required this.brand,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.actionLabel,
  });

  final String brand;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String actionLabel;
}
