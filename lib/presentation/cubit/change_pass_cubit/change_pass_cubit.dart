import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/change_passwoed_usecase.dart';
import 'package:hatley/presentation/cubit/change_pass_cubit/change_pass_state.dart';

class ChangePassCubit extends Cubit<ChangePassState> {
  final ChangePasswordUsecase changePasswordUsecase;

  ChangePassCubit(this.changePasswordUsecase) : super(ChangePassInitial());

  Future<void> changePassword(String oldPass, String newPass) async {
    emit(ChangePassLoading());

    final result = await changePasswordUsecase(oldPass, newPass);

    result.fold(
      (failure) {
        emit(ChangePassFailure(failure.message));
      },
      (_) {
        emit(ChangePassSuccess());
      },
    );
  }
}
