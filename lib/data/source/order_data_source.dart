import 'package:dio/dio.dart';
import 'package:shop_project/data/order.dart';
import 'package:shop_project/data/payment_receipt.dart';
import 'package:shop_project/data/user.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(String orderId);
  Future<List<OrderEntity>> getOrders();
  Future<UserEntity> getUserInfo();
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post('user/addOrder', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'postal_code': params.postalCode,
      'mobile': params.mobile,
      'address': params.address,
      'overall_height': params.overallHeight,
      'size': params.size,
      'payable_price': params.payablePrice,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery'
    });

    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(String orderId) async {
    final response = await httpClient.get('user/checkout?order_id=$orderId');
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<UserEntity> getUserInfo() async {
    final response = await httpClient.get('user/info');
    return UserEntity.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get('user/orderList');
    return (response.data as List)
        .map((item) => OrderEntity.fromJson(item))
        .toList();
  }
}
