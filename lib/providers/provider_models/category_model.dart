class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.key,
    required this.name,
    required this.icon,
  });

  final int id;
  final String key;
  final String name;
  final String icon;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
        key: json['key'] ?? '',
        name: json['name'] ?? '',
        icon: json['icon'] ?? '');
  }
}
