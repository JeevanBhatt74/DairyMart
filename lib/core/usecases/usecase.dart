import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';

/// Base class for all UseCases.
/// [Type] is the success return type.
/// [Params] is the input parameter type.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this when no parameters are required for a UseCase.
class NoParams {}

