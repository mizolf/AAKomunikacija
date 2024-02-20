class Pictogram {
  const Pictogram(
      {required this.label,
      required this.image,
      required this.custom,
      required this.description,
      required this.category});

  final String label;
  final String image;
  final String description;
  final bool custom;
  final String category;

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'image': image,
      'custom': custom,
      'category': category,
      'description': description,
    };
  }

  factory Pictogram.fromMap(Map<String, dynamic> map) {
    return Pictogram(
      label: map['label'] ?? '',
      image: map['image'] ?? '',
      custom: map['custom'] ?? true,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
