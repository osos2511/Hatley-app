import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/domain/usecases/logout_usecase.dart';
import 'package:hatley/domain/usecases/signIn_usecase.dart';
import '../../../core/local/token_storage.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase useCase;
  final LogOutUseCase logOutUseCase;
  final TokenStorage tokenStorage;

  AuthCubit(
      this.useCase,
      this.tokenStorage,
      this.logOutUseCase,
      ) : super(SignInInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());

    final result = await useCase.call(email: email, password: password);

    result.fold(
          (failure) {
        print('❌ Login failed: ${failure.message}');
        emit(SignInFailure(failure.message));
      },
          (authEntity) {
        print('✅ Login success: ${authEntity.token}');
        emit(SignInSuccess(authEntity.token));
      },
    );
  }

  Future<void> logOut() async {
    emit(LogoutLoading());

    final result = await logOutUseCase.call();

    result.fold(
          (failure) {
        print('❌ Logout failed: ${failure.message}');
        emit(LogoutFailure(failure.message));
      },
          (_) async {
        print('✅ Logout success');
        await tokenStorage.clearToken();
        emit(LogoutSuccess());
      },
    );
  }

  /// هذه الميثود لا تُرجع أي قيمة، فقط تحدّث الحالة حسب صلاحية التوكن
  Future<void> checkTokenAndNavigate() async {
    final token = await tokenStorage.getToken();
    final expirationStr = await tokenStorage.getExpiration();

    print('🔍 Retrieved token: $token');
    print('📦 Stored expiration string: $expirationStr');

    if (expirationStr == null) {
      print('⚠️ No expiration date found. Token considered expired.');
      await tokenStorage.clearToken();
      emit(TokenInvalid());
      return;
    }

    final expiration = DateTime.tryParse(expirationStr);
    if (expiration == null || DateTime.now().isAfter(expiration)) {
      print('⏳ Token expired. Clearing...');
      await tokenStorage.clearToken();
      emit(TokenInvalid());
    } else {
      print('✅ Token is valid.');
      emit(TokenValid());
    }
  }
}
