import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/register_usecase.dart';
import 'package:hatley/presentation/cubit/register_cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase useCase;

  RegisterCubit(this.useCase) : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String userName,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoading());

    final result = await useCase(
      email: email,
      userName: userName,
      password: password,
      phone: phone,
    );

    result.fold(
      (failure) {
        print('register failed: ${failure.message}');
        emit(RegisterFailure(failure.message));
      },
      (message) {
        print('register success: $message');
        emit(RegisterSuccess(message));
      },
    );
  }
}
