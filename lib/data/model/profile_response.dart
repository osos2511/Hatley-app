class ProfileResponse {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String? photo;

  ProfileResponse({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.photo,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'photo': photo,
    };
  }
}
