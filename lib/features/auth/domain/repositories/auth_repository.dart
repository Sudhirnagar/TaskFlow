import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

// Domain contract defining available authentication operations independent of implementation
abstract class AuthRepository {
  // Core authentication methods returning either a failure or the User entity
  Future<Either<Failure, User>> register(String email, String password);
  Future<Either<Failure, User>> login(String email, String password);

  // Terminates the current user session
  Future<Either<Failure, void>> logout();

  // Retrieves the currently authenticated user if a valid session exists
  Future<Either<Failure, User?>> getCurrentUser();

  // Stream providing real-time updates on user authentication state (logged in/out)
  Stream<User?> get authStateChanges;
}