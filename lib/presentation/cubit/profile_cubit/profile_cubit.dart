import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_profile_info_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileInfoUsecase getProfileInfoUseCase;

  ProfileCubit({required this.getProfileInfoUseCase}) : super(ProfileInitial());

  Future<void> getProfileInfo() async {
    emit(ProfileLoading());
    final result = await getProfileInfoUseCase();
    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (profile) {
        emit(ProfileLoaded(profile));
      },
    );
  }
}
