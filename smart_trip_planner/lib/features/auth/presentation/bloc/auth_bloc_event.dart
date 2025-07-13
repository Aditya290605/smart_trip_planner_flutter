// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class AuthSignUp extends AuthBlocEvent {
  final String email;
  final String name;
  final String password;

  AuthSignUp({required this.email, required this.password, required this.name});
}

class AuthSignIn extends AuthBlocEvent {
  final String email;
  final String pass;
  AuthSignIn({required this.email, required this.pass});
}

class UserCurrentLogin extends AuthBlocEvent {}
