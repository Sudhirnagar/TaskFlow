// lib/features/auth/domain/usecases/register_user.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// Encapsulates the business logic for creating a new user account
class RegisterUser implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  // Executes the registration operation using the provided credentials
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(params.email, params.password);
  }
}

// Container for credentials required to create a new account
class RegisterParams {
  final String email;
  final String password;

  RegisterParams({required this.email, required this.password});
}