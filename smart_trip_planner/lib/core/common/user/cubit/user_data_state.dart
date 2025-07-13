part of 'user_data_cubit.dart';

@immutable
sealed class UserDataState {}

final class UserDataInitial extends UserDataState {}

final class UserLoggedIn extends UserDataState {
  final UserProfile user;

  UserLoggedIn({required this.user});
}
