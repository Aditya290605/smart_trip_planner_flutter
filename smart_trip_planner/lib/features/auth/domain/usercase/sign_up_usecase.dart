import 'package:fpdart/fpdart.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';
import 'package:smart_trip_planner/core/errors/errors.dart';
import 'package:smart_trip_planner/core/usecase/use_case.dart';
import 'package:smart_trip_planner/features/auth/domain/repository/auth_repository.dart';

class SignUpUsecase implements UseCase<UserProfile, SignUpParams> {
  final AuthRepository _authRepository;

  SignUpUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<UserProfile, Failures>> call(params) async {
    return await _authRepository.signUpWithEmailAndPass(
      name: params.name,
      email: params.email,
      password: params.pass,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String pass;

  SignUpParams({required this.name, required this.email, required this.pass});
}
