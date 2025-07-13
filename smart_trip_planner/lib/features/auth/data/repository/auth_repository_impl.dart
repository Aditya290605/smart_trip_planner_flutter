import 'package:fpdart/fpdart.dart';
import 'package:smart_trip_planner/core/entities/user_profile.dart';
import 'package:smart_trip_planner/core/errors/errors.dart';
import 'package:smart_trip_planner/core/errors/server_exception.dart';
import 'package:smart_trip_planner/features/auth/data/data_source/auth_remote_data_soucre.dart';
import 'package:smart_trip_planner/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSoucre _dataSoucre;

  AuthRepositoryImpl({required RemoteDataSoucre dataSoucre})
    : _dataSoucre = dataSoucre;

  @override
  Future<Either<UserProfile, Failures>> signInWithEmailAndPass({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<UserProfile, Failures>> signUpWithEmailAndPass({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dataSoucre.signUpWithEmailAndPass(
        name: name,
        email: email,
        pass: password,
      );

      return Left(res);
    } on ServerException catch (e) {
      return Right(Failures(error: e.exception));
    } catch (e) {
      throw ServerException(exception: e.toString());
    }
  }

  @override
  Future<Either<UserProfile, Failures>> getUserProfile() async {
    try {
      final res = await _dataSoucre.getUserData();
      if (res != null) {
        return Left(res);
      }
      return Right(Failures(error: "User not found"));
    } catch (e) {
      throw ServerException(exception: e.toString());
    }
  }
}
