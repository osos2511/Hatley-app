import 'package:hatley/data/model/profile_response.dart';
import 'package:hatley/domain/entities/profile_entity.dart';

extension ProfileMapper on ProfileResponse {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      phone: phone,
      email: email,
      photo: photo,
    );
  }
}
