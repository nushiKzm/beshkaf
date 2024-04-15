import 'package:flutter/foundation.dart';
import 'package:shop_project/common/http_client.dart';
import 'package:shop_project/data/cart_item.dart';
import 'package:shop_project/data/add_to_cart_response.dart';
import 'package:shop_project/data/cart_response.dart';
import 'package:shop_project/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCountNotifier = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(String productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(String cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartItemCountNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(String cartItemId) async {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
