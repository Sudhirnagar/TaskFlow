import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

// Encapsulates the business logic for authenticating an existing user
class LoginUser implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  // Executes the login operation using the provided credentials
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

// Container for credentials required to perform the login operation
class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}