import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_project/data/auth_info.dart';
// import 'package:shop_project/data/common/constants.dart';
import 'package:shop_project/data/common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> signUp(String username, String password);
  // Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post("user/login", data: {
      // "grant_type": "password",
      // "client_id": 2,
      // "client_secret": Constants.clientSecret,
      "username": username,
      "password": password
    });
    validateResponse(response);

    return AuthInfo(
        '${response.headers['x-auth-token']?[0]}', response.data['name']);
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    final response = await httpClient.post('user/register',
        data: {"username": username, "password": password});
    validateResponse(response);

    return AuthInfo('${response.headers['x-auth-token']?[0]}', '');
  }
}
