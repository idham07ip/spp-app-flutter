part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final SignInFormModel data;
  const AuthLogin(this.data);

  @override
  List<Object> get props => [data];
}

class AuthLogout extends AuthEvent {}

class AuthGetCurrentUser extends AuthEvent {}

class AuthUpdateUser extends AuthEvent {
  final UserEditFormModel data;
  const AuthUpdateUser(this.data);

  @override
  List<Object> get props => [data];
}
