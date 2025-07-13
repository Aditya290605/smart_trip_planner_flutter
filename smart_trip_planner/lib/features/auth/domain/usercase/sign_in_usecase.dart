import 'package:fpdart/fpdart.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';
import 'package:smart_trip_planner/core/errors/errors.dart';
import 'package:smart_trip_planner/core/usecase/use_case.dart';
import 'package:smart_trip_planner/features/auth/domain/repository/auth_repository.dart';

class SignInUsecase implements UseCase<UserProfile, SingInParams> {
  final AuthRepository _authRepository;

  SignInUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<UserProfile, Failures>> call(SingInParams params) async {
    return await _authRepository.signInWithEmailAndPass(
      email: params.email,
      password: params.pass,
    );
  }
}

class SingInParams {
  final String email;
  final String pass;

  SingInParams({required this.email, required this.pass});
}
