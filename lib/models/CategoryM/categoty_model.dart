class CategoryModelMain {
  final int id;
  final String name;
  final String image;

  CategoryModelMain({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModelMain.fromJson(Map<String, dynamic> json) {
    return CategoryModelMain(
      id: json['id'],
      name: json['name'],
      image: "https://www.online-tech.in/${json['catogary_Image']}", // attach base url
    );
  }
}
