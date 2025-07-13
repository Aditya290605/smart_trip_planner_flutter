import 'package:fpdart/fpdart.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';
import 'package:smart_trip_planner/core/errors/errors.dart';

abstract interface class AuthRepository {
  Future<Either<UserProfile, Failures>> signUpWithEmailAndPass({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<UserProfile, Failures>> signInWithEmailAndPass({
    required String email,
    required String password,
  });

  Future<Either<UserProfile, Failures>> getUserProfile();
}
