class Pictogram {
  const Pictogram(
      {required this.title,
      required this.image,
      required this.custom,
      required this.category});

  final String title;
  final String image;
  final bool custom;
  final String category;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'custom': custom,
      'category': category
    };
  }

  factory Pictogram.fromMap(Map<String, dynamic> map) {
    return Pictogram(
      title: map['title'] ?? '',
      image: map['image'] ?? '',
      custom: map['custom'] ?? true,
      category: map['category'] ?? '',
    );
  }
}
