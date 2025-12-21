import 'package:fpdart/fpdart.dart';
import 'package:safeguard_ai/core/errors/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

