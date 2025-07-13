import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/common/user/cubit/user_data_cubit.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';
import 'package:smart_trip_planner/core/usecase/use_case.dart';
import 'package:smart_trip_planner/features/auth/domain/usercase/sign_up_usecase.dart';
import 'package:smart_trip_planner/features/auth/domain/usercase/user_auth_usecase.dart';
part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final SignUpUsecase _signUpUsecase;
  final UserAuthUsecase _usecase;
  final UserDataCubit _userDataCubit;

  AuthBlocBloc({
    required SignUpUsecase signUpUseCase,
    required UserAuthUsecase usecasae,
    required UserDataCubit userDataCubit,
  }) : _signUpUsecase = signUpUseCase,
       _usecase = usecasae,
       _userDataCubit = userDataCubit,
       super(AuthInitial()) {
    on<AuthBlocEvent>((_, emit) => emit(AuthLoading()));

    on<AuthSignUp>((event, emit) async {
      final res = await _signUpUsecase.call(
        SignUpParams(
          name: event.name,
          email: event.email,
          pass: event.password,
        ),
      );

      res.fold((l) => emit(AuthSuccess(l)), (r) => emit(AuthFailure(r.error)));
    });

    on<UserCurrentLogin>((event, emit) async {
      final res = await _usecase.call(NoParams());

      res.fold((l) {
        _userDataCubit.updateUser(l);
        emit(AuthSuccess(l));
      }, (r) => emit(AuthFailure(r.error)));
    });
  }
}
