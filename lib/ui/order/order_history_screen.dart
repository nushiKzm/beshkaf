import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/repo/order_repository.dart';
import 'package:shop_project/ui/order/bloc/order_history_bloc.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سوابق پرداخت"),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 1)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('شناسه سفارش'), Text(order.mobile)],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('مبلغ'),
                              Text(order.payablePrice.withPriceLabel)
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                            itemCount: order.items.length,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            itemBuilder: (context, index) => Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(left: 4, right: 4),
                              child: ImageLoadingService(
                                borderRadius: BorderRadius.circular(8),
                                imageUrl: ((order.items[index].imageUrl)
                                        .replaceAll(r'\', "/"))
                                    .replaceAll(
                                        'uploads', 'http://10.0.2.2:3000'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
