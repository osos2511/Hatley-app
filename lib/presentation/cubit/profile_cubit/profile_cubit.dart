import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/updateProfile_usecase.dart';
import 'package:hatley/domain/usecases/upload_profile_img_usecase.dart';
import '../../../domain/usecases/get_profile_info_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileInfoUsecase getProfileInfoUseCase;
  final UploadProfileImgUsecase uploadProfileImgUsecase;
  final UpdateprofileUsecase updateProfileUsecase;

  ProfileCubit({
    required this.getProfileInfoUseCase,
    required this.updateProfileUsecase,
    required this.uploadProfileImgUsecase,
  }) : super(ProfileState());

  Future<void> getProfileInfo() async {
    emit(state.copyWith(isLoadingProfile: true, errorMessage: null));

    final result = await getProfileInfoUseCase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingProfile: false,
            errorMessage: failure.message,
          ),
        );
      },
      (profile) {
        emit(
          state.copyWith(
            isLoadingProfile: false,
            profile: profile,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> uploadProfileImage(File imagePath) async {
    emit(state.copyWith(isUploadingImage: true, errorMessage: null));

    final result = await uploadProfileImgUsecase(imagePath);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUploadingImage: false,
            errorMessage: failure.message,
          ),
        );
      },
      (imageUrl) {
        emit(
          state.copyWith(
            isUploadingImage: false,
            uploadedImageUrl: imageUrl,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> updateProfile(String name, String email, String phone) async {
    emit(state.copyWith(isUpdatingProfile: true, errorMessage: null));

    final result = await updateProfileUsecase(name, email, phone);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isUpdatingProfile: false,
            errorMessage: failure.message,
          ),
        );
      },
      (_) async {
        await getProfileInfo();
        emit(state.copyWith(isUpdatingProfile: false, errorMessage: null));
      },
    );
  }
}
