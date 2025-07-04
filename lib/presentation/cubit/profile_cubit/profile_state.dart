import '../../../domain/entities/profile_entity.dart';

class ProfileState {
  final bool isLoadingProfile; // هل بيانات البروفايل بتتحمل؟
  final bool isUploadingImage; // هل صورة البروفايل بتترفع؟
  final ProfileEntity? profile; // بيانات البروفايل نفسها
  final String? uploadedImageUrl; // رابط الصورة المرفوعة (لو فيه)
  final String? errorMessage; // رسالة الخطأ (لو فيه خطأ)
  final bool isUpdatingProfile;

  ProfileState({
    this.isLoadingProfile = false,
    this.isUploadingImage = false,
    this.profile,
    this.uploadedImageUrl,
    this.errorMessage,
    this.isUpdatingProfile = false,
  });

  ProfileState copyWith({
    bool? isLoadingProfile,
    bool? isUploadingImage,
    ProfileEntity? profile,
    String? uploadedImageUrl,
    String? errorMessage,
    bool? isUpdatingProfile,
  }) {
    return ProfileState(
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      profile: profile ?? this.profile,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      errorMessage: errorMessage,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
    );
  }
}
