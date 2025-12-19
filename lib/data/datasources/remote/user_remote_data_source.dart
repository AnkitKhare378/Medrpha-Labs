import '../../models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/error/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getUserById(String id) async {
    final response = await client.get("${ApiEndpoints.users}/$id");

    if (response.isNotEmpty) {
      return UserModel.fromJson(response);
    } else {
      throw ServerException("User not found");
    }
  }
}


