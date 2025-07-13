import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());

  void updateUser(UserProfile? user) {
    if (user == null) {
      debugPrint('user is null');
      emit(UserDataInitial());
    } else {
      emit(UserLoggedIn(user: user));
    }
  }
}
