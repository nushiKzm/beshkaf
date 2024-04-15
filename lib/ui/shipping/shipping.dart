import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/order.dart';
import 'package:shop_project/data/repo/order_repository.dart';
import 'package:shop_project/ui/cart/price_info.dart';
import 'package:shop_project/ui/payment_webview.dart';
import 'package:shop_project/ui/receipt/payment_receipt.dart';
import 'package:shop_project/ui/shipping/bloc/shipping_bloc.dart';
// import 'package:shop_project/ui/receipt/payment_receipt.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  StreamSubscription? subscription;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController overallHeightController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          bloc.add(ShippingStarted());
          subscription = bloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.appException.message)));
            } else if (event is ShippingSuccess) {
              if (event.result.bankGatewayUrl.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentGatewayScreen(
                            bankGatewayUrl: event.result.bankGatewayUrl)));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentReceiptScreen(orderId: event.result.orderId),
                  ),
                );
              }
            } else if (event is ShippingShow) {
              firstNameController.text = event.info.firstName;
              lastNameController.text = event.info.lastName;
              mobileController.text = event.info.mobile;
              addressController.text = event.info.address;
              postalCodeController.text = event.info.postalCode;
              overallHeightController.text = '${event.info.overallHeight}';
              sizeController.text = '${event.info.size}';
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(label: Text('نام')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(label: Text('شماره تماس')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(label: Text('کد پستی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(label: Text('آدرس')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: sizeController,
                decoration: InputDecoration(label: Text('سایز')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: overallHeightController,
                decoration: InputDecoration(label: Text('قد کل')),
              ),
              const SizedBox(
                height: 12,
              ),
              PriceInfo(
                  payablePrice: widget.payablePrice,
                  shippingCost: widget.shippingCost,
                  totalPrice: widget.totalPrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ShippingBloc>(context).add(
                                ShippingCreateOrder(CreateOrderParams(
                                    firstNameController.text,
                                    lastNameController.text,
                                    postalCodeController.text,
                                    mobileController.text,
                                    addressController.text,
                                    int.parse(overallHeightController.text),
                                    int.parse(sizeController.text),
                                    widget.payablePrice,
                                    PaymentMethod.online)));
                          },
                          child: const Text('پرداخت'),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               OutlinedButton(
//                                   onPressed: () {
//                                     BlocProvider.of<ShippingBloc>(context).add(
//                                         ShippingCreateOrder(CreateOrderParams(
//                                             firstNameController.text,
//                                             lastNameController.text,
//                                             postalCodeController.text,
//                                             mobileController.text,
//                                             addressController.text,
//                                             int.parse(
//                                                 overallHeightController.text),
//                                             int.parse(sizeController.text),
//                                             PaymentMethod.cashOnDelivery)));
//                                   },
//                                   child: const Text('پرداخت در محل')),
//                               const SizedBox(
//                                 width: 16,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   BlocProvider.of<ShippingBloc>(context).add(
//                                       ShippingCreateOrder(CreateOrderParams(
//                                           firstNameController.text,
//                                           lastNameController.text,
//                                           postalCodeController.text,
//                                           mobileController.text,
//                                           addressController.text,
//                                           int.parse(
//                                               overallHeightController.text),
//                                           int.parse(sizeController.text),
//                                           PaymentMethod.online)));
//                                 },
//                                 child: const Text('پرداخت اینترنتی'),
//                               ),
//                             ],
//                           );