import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<Either<Failure, UserEntity>> call(String id) {
    return repository.getUserById(id);
  }
}
