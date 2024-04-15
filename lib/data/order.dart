import 'package:shop_project/data/product.dart';

class CreateOrderResult {
  final String orderId;
  final String bankGatewayUrl;

  CreateOrderResult(this.orderId, this.bankGatewayUrl);
  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String postalCode;
  final String mobile;
  final String address;
  final int overallHeight;
  final int size;
  final int payablePrice;
  final PaymentMethod paymentMethod;

  CreateOrderParams(
      this.firstName,
      this.lastName,
      this.postalCode,
      this.mobile,
      this.address,
      this.overallHeight,
      this.size,
      this.payablePrice,
      this.paymentMethod);
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntity {
  final String id;
  final String mobile;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id, this.mobile, this.payablePrice, this.items);
  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        mobile = json['mobile'],
        payablePrice = json['payable_price'],
        items = (json['items'] as List)
            .map((item) => ProductEntity.fromJson(item['product_id']))
            .toList();
}
