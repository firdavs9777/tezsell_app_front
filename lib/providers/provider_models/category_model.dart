class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.key,
    required this.name,
  });

  final int id;
  final String key;
  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      key: json['key'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
