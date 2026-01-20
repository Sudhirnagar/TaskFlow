import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

// Base interface for all business logic units enforcing functional error handling
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Placeholder class for use cases that do not require input arguments
class NoParams {}