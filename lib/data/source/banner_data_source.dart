import 'package:dio/dio.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/data/banner.dart';
import 'package:shop_project/data/common/http_response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('user/banner/slider');
    validateResponse(response);
    final banners = <BannerEntity>[];
    (response.data as List).forEach((jsonObject) {
      banners.add(BannerEntity.fromJson(jsonObject));
    });
    return banners;
  }
}
