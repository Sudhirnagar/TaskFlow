import 'package:equatable/equatable.dart';

// Base abstract class for all application failures, supporting value comparison
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

// Represents failures arising from network connections or API server issues
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Represents authentication errors such as invalid credentials or session expiration
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Represents failures related to local data storage or cache retrieval
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Represents failures due to invalid user input or business rule violations
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}