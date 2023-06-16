import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spp_app/model/sign_in_form_model.dart';
import 'package:spp_app/model/user_edit_form_model.dart';
import 'package:spp_app/model/user_model.dart';
import 'package:spp_app/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLogin) {
        try {
          emit(AuthLoading());

          final res = await AuthService().login(event.data);
          emit(AuthSuccess(res));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthGetCurrentUser) {
        try {
          emit(AuthLoading());
          final SignInFormModel data =
              await AuthService().getCredentialFromLocal();

          final UserModel user = await AuthService().login(data);
          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpdateUser) {
        try {
          if (state is AuthSuccess) {
            final updatedUser = (state as AuthSuccess).user.copyWith(
                  nama_siswa: event.data.nama_siswa,
                  password: event.data.password,
                );

            emit(AuthLoading());

            await AuthService().updateUser(event.data);

            emit(AuthSuccess(updatedUser));
          } else {
            throw Exception('Invalid state');
          }
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthLogout) {
        try {
          emit(AuthLoading());

          await AuthService().Logout();
          emit(AuthInitial());
        } catch (e) {
          AuthFailed(e.toString());
        }
      }
    });
  }
}
