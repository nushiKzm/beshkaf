import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/common/http_client.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/favorite_manager.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/repo/cart_repository.dart';
import 'package:shop_project/theme.dart';
import 'package:shop_project/ui/product/bloc/product_bloc.dart';
import 'package:shop_project/ui/widgets/image.dart';
import 'comment/comment_list.dart';
import 'package:shop_project/data/repo/comment_repository.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  void dispose() {
    //هر وقت این صفحه بخواد  از بین بره این فانکشن کال میشه
    _scaffoldKey.currentState?.dispose();
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("با موفقیت به سبد سفارش شما اضافه شد")));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => FloatingActionButton.extended(
                  onPressed: () {
                    BlocProvider.of<ProductBloc>(context)
                        .add(CartAddButtonClick(widget.product.id));
                  },
                  label: state is ProductAddToCartButtonLoading
                      ? CupertinoActivityIndicator(
                          color: Theme.of(context).colorScheme.onSecondary,
                        )
                      : const Text('افزودن به سبد سفارش'),
                ),
              ),
            ),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 1.2,
                  flexibleSpace: ImageLoadingService(
                      imageUrl:
                          ((widget.product.imageUrl).replaceAll(r'\', "/"))
                              .replaceAll('uploads', 'http://10.0.2.2:3000')),
                  foregroundColor: LightThemeColors.primaryTextColor,
                  actions: [
                    IconButton(
                        onPressed: () {
                          if (!favoriteManager.isFavorites(widget.product)) {
                            favoriteManager.addFavorite(widget.product);
                          } else {
                            favoriteManager.deleteFavorite(widget.product);
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          favoriteManager.isFavorites(widget.product)
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                        ))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.product.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                Text(widget.product.price.withPriceLabel),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          widget.product.description,
                          style: const TextStyle(height: 1.4),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      useRootNavigator: true,
                                      context: context,
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: const Text('دیدگاه شما'),
                                            content: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'دیدگاه خود را شرح دهید',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  TextField(
                                                    controller: titleController,
                                                    decoration:
                                                        const InputDecoration(
                                                            label: Text(
                                                                'عنوان نظر'),
                                                            isDense: true,
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    8)),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  SizedBox(
                                                    height: 100,
                                                    child: TextField(
                                                      controller:
                                                          contentController,
                                                      decoration:
                                                          const InputDecoration(
                                                        label: Text('متن نظر'),
                                                      ),
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('بستن')),
                                              TextButton(
                                                  onPressed: () async {
                                                    final res =
                                                        await commentRepository
                                                            .add(
                                                                widget
                                                                    .product.id,
                                                                titleController
                                                                    .text,
                                                                contentController
                                                                    .text);
                                                    if (res) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child:
                                                      const Text('ثبت دیدگاه')),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Text('ثبت نظر'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id),
                // SizedBox(
                //   height: 12,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
