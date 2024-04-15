import 'package:dio/dio.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/source/product_data_source.dart';
import 'package:shop_project/common/http_client.dart';
import 'package:shop_project/data/source/profile_info_data_source.dart';
import 'package:shop_project/data/user.dart';

final profileRepository =
    ProfileRepository(ProfileRemoteDataSource(httpClient));

abstract class IProfileRepository {
  Future<UserEntity> getInfo();
  Future<UserEntity> updateInfo(UserEntity params);
}

class ProfileRepository implements IProfileRepository {
  final IProfileDataSource dataSource;

  ProfileRepository(this.dataSource);

  @override
  Future<UserEntity> getInfo() => dataSource.getInfo();

  @override
  Future<UserEntity> updateInfo(UserEntity params) =>
      dataSource.updateInfo(params);
}
