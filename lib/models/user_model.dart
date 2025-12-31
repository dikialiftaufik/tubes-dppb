class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profilePhoto; // Nullable jika user belum pasang foto

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      profilePhoto: json['foto_profile'] as String?, // Sesuaikan dengan nama kolom di database kamu
    );
  }
}