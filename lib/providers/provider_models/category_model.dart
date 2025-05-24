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
}
