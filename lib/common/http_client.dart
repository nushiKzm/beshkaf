import 'package:dio/dio.dart';
import 'package:shop_project/data/repo/auth_repository.dart';

final httpClient = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000/api/'))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (authInfo != null && authInfo.accessToken.isNotEmpty) {
        options.headers['x-auth-token'] = '${authInfo.accessToken}';
      }

      handler.next(options);
    },
  ));
