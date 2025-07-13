import 'package:fpdart/fpdart.dart';
import 'package:smart_trip_planner/core/errors/errors.dart';

abstract interface class UseCase<SucessType, Params> {
  Future<Either<SucessType, Failures>> call(Params params);
}

class NoParams {}
