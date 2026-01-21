import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

// Encapsulates the business logic for terminating the user session
class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUser(this.repository);

  // Executes the repository operation to sign out the current user
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}