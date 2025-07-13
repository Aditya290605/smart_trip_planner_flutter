import 'package:fpdart/fpdart.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';
import 'package:smart_trip_planner/core/errors/errors.dart';
import 'package:smart_trip_planner/core/usecase/use_case.dart';
import 'package:smart_trip_planner/features/auth/domain/repository/auth_repository.dart';

class UserAuthUsecase implements UseCase<UserProfile, NoParams> {
  final AuthRepository _authRepository;

  UserAuthUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<UserProfile, Failures>> call(NoParams params) async {
    return await _authRepository.getUserProfile();
  }
}
