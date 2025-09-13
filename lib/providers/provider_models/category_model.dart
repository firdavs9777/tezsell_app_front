class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.key,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
    required this.icon,
  });

  final int id;
  final String key;
  final String nameUz;
  final String nameRu;
  final String nameEn;
  final String icon;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
        key: json['key'] ?? '',
        nameUz: json['name_uz'] ?? '',
        nameRu: json['name_ru'] ?? '',
        nameEn: json['name_en'] ?? '',
        icon: json['icon'] ?? '');
  }

  // Add equality comparison based on ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  // Optional: Add toString for debugging
  @override
  String toString() {
    return 'CategoryModel(id: $id, key: $key, nameEn: $nameEn)';
  }
}
