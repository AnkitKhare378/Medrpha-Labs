import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_data_source.dart';
import '../datasources/remote/user_remote_data_source.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      // Optionally save to cache
      await localDataSource.cacheUser(user);
      return Right(user as UserEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
