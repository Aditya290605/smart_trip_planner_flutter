part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class AuthSignUp extends AuthBlocEvent {
  final String email;
  final String name;
  final String password;

  AuthSignUp({required this.email, required this.password, required this.name});
}

class UserCurrentLogin extends AuthBlocEvent {}
