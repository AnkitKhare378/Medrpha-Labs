class CompanyModel {
  final int id;
  final String name;
  final String? address;
  final String? emailid;
  final String? image;

  CompanyModel({
    required this.id,
    required this.name,
    this.address,
    this.emailid,
    this.image,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'],
      emailid: json['emailid'],
      image: json['image'],
    );
  }
}