import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import '../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class HomeViewModel {
  final GetUserById getUserById;

  HomeViewModel({required this.getUserById});

  Future<Either<Failure, UserEntity>> fetchUser(String id) {
    return getUserById(id);
  }
}
