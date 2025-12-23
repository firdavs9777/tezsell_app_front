class PropertyImage {
  final int id;
  final String image;
  final String caption;

  const PropertyImage({
    required this.id,
    required this.image,
    required this.caption,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      caption: json['caption'] ?? '',
    );
  }
}

