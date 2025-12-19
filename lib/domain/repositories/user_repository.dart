import '../entities/user_entity.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserById(String id);
}
