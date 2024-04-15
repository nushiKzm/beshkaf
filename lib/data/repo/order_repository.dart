import 'package:shop_project/common/http_client.dart';
import 'package:shop_project/data/order.dart';
import 'package:shop_project/data/payment_receipt.dart';
import 'package:shop_project/data/source/order_data_source.dart';
import 'package:shop_project/data/user.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(String orderId) =>
      dataSource.getPaymentReceipt(orderId);

  @override
  Future<UserEntity> getUserInfo() => dataSource.getUserInfo();

  @override
  Future<List<OrderEntity>> getOrders() {
    return dataSource.getOrders();
  }
}
