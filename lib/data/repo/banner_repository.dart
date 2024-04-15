import 'package:dio/dio.dart';
import 'package:shop_project/data/banner.dart';
import 'package:shop_project/data/source/banner_data_source.dart';
import 'package:shop_project/common/http_client.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
