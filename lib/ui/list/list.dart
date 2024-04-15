import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/repo/product_repository.dart';
import 'package:shop_project/ui/list/bloc/product_list_bloc.dart';
import 'package:shop_project/ui/product/product.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  ProductListScreen({Key? key, required this.sort}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid;

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ژورنال مزون بشکاف')),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          return bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort));
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                  Container(
                    // margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20)
                        ]),
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                ),
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 250,
                                    child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Text(
                                              'انتخاب مرتب سازی',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      state.sortNames.length,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    final selectedIndex =
                                                        state.sort;
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                          onTap: () {
                                                            bloc!.add(
                                                                ProductListStarted(
                                                                    index));
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(state
                                                                      .sortNames[
                                                                  index]),
                                                              if (selectedIndex ==
                                                                  index)
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              8.0),
                                                                  child: Icon(
                                                                    CupertinoIcons
                                                                        .check_mark_circled_solid,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                  ),
                                                                )
                                                            ],
                                                          )),
                                                    );
                                                  })),
                                            ),
                                          ],
                                        )),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.sort_down)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('مرتب سازی'),
                                  Text(
                                    ProductSort.names[state.sort],
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                        Container(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.grid
                                      ? ViewType.list
                                      : ViewType.grid;
                                });
                              },
                              icon: Icon(viewType == ViewType.grid
                                  ? CupertinoIcons.square_grid_2x2
                                  : CupertinoIcons.square_list)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: viewType == ViewType.grid ? 2 : 1,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                            product: product, borderRadius: BorderRadius.zero);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
    );
  }
}
