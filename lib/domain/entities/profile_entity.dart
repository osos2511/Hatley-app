class ProfileEntity {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? photo;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.photo,
  });
}
