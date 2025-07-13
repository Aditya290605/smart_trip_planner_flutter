part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthInitial extends AuthBlocState {}

final class AuthLoading extends AuthBlocState {}

final class AuthSuccess extends AuthBlocState {
  final UserProfile user;

  AuthSuccess(this.user);
}

final class AuthFailure extends AuthBlocState {
  final String error;

  AuthFailure(this.error);
}
