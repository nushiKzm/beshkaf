import 'package:dio/dio.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/common/http_response_validator.dart';
import 'package:shop_project/data/user.dart';

abstract class IProfileDataSource {
  Future<UserEntity> getInfo();
  Future<UserEntity> updateInfo(UserEntity params);
}

class ProfileRemoteDataSource
    with HttpResponseValidator
    implements IProfileDataSource {
  final Dio httpClient;

  ProfileRemoteDataSource(this.httpClient);

  @override
  Future<UserEntity> getInfo() async {
    final response = await httpClient.get('user/info');
    validateResponse(response);
    // if(response.data.length<2){
    //   return UserEntity.fromJson(response.data);
    // }
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<UserEntity> updateInfo(UserEntity params) async {
    final response = await httpClient.post('user/updateProfile', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'postal_code': params.postalCode,
      'mobile': params.mobile,
      'address': params.address,
      'overall_height': params.overallHeight,
      'size': params.size,
    });
    validateResponse(response);
    return UserEntity.fromJson(response.data);
  }
}
