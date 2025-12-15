import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base parameters class
abstract class Params extends Equatable {}

/// No parameters class
class NoParams extends Params {
  @override
  List<Object> get props => [];
}

/// Base use case interface
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case without parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

