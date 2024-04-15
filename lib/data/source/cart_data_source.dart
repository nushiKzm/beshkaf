import 'package:dio/dio.dart';
import 'package:shop_project/data/cart_item.dart';
import 'package:shop_project/data/add_to_cart_response.dart';
import 'package:shop_project/data/cart_response.dart';
import 'package:shop_project/data/common/http_response_validator.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(String productId);
  Future<AddToCartResponse> changeCount(String cartItemId, int count);
  Future<void> delete(String cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource
    with HttpResponseValidator
    implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);

  @override
  Future<AddToCartResponse> add(String productId) async {
    final response = await httpClient.get('user/updateBasket/$productId');
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(String cartItemId, int count) async {
    final response = await httpClient.post('user/changeItemCount',
        data: {'item_id': cartItemId, "count": count});
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('user/countItems');
    validateResponse(response);
    return response.data['count'];
  }

  @override
  Future<void> delete(String cartItemId) async {
    await httpClient.delete('user/removeItemFromBasket/$cartItemId');
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('user/basketList');
    validateResponse(response);
    return CartResponse.fromJson(response.data);
  }
}
