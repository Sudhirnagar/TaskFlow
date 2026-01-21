import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

// Bridge between the Domain layer (Interfaces) and Data layer (Data Sources)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> register(String email, String password) async {
    try {
      // Delegate registration to remote source and return success
      final user = await remoteDataSource.register(email, password);
      return Right(user);
    } on AuthException catch (e) {
      // Map specific data exceptions to domain failures
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Delegate login to remote source and return user entity
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      // Catch unexpected errors and return as Failure instead of crashing
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Perform sign out operation
      await remoteDataSource.logout();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Check for an existing session and retrieve user data
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to get current user'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    // Expose the raw stream of auth state changes from the data source
    return remoteDataSource.authStateChanges;
  }
}