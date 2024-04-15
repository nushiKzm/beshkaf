// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/auth_info.dart';
import 'package:shop_project/data/cart_item.dart';
import 'package:shop_project/data/repo/auth_repository.dart';
import 'package:shop_project/data/repo/cart_repository.dart';
import 'package:shop_project/ui/auth/auth.dart';
import 'package:shop_project/ui/cart/bloc/cart_bloc.dart';
import 'package:shop_project/ui/cart/cart_item.dart';
import 'package:shop_project/ui/cart/price_info.dart';
import 'package:shop_project/ui/shipping/shipping.dart';
import 'package:shop_project/ui/widgets/empty_view.dart';
import 'package:shop_project/ui/widgets/image.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? stateStreamSubscription;
  bool stateIsSuccess = false;
  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("سبد سفارش"),
        ),
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            margin: EdgeInsets.only(left: 48, right: 48),
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShippingScreen(
                            payablePrice: state.cartResponse.payablePrice,
                            totalPrice: state.cartResponse.totalPrice,
                            shippingCost: state.cartResponse.shippingCost),
                      ),
                    );
                  }
                },
                label: Text("ادامه")),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            stateStreamSubscription = bloc.stream.listen((state) {
              setState(() {
                stateIsSuccess = state is CartSuccess;
              });

              if (_refreshController.isRefresh) {
                if (state is CartSuccess || state is CartEmpty) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is CartSuccess) {
              return SmartRefresher(
                header: ClassicHeader(
                  completeText: "موفق",
                  refreshingText: 'در حال بروزرسانی',
                  idleText: 'برای بروزرسانی پایین بکشید',
                  releaseText: 'رها کنید',
                  failedText: "خطای نامشخص",
                  spacing: 2,
                  completeIcon:
                      Icon(CupertinoIcons.checkmark_circle, color: Colors.grey),
                ),
                controller: _refreshController,
                onRefresh: () {
                  cartBloc?.add(CartStarted(
                      AuthRepository.authChangeNotifier.value,
                      isRefreshing: true));
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    if (index < state.cartResponse.cartItems.length) {
                      final data = state.cartResponse.cartItems[index];
                      return CartItem(
                        data: data,
                        onDeleteButtonClicked: () {
                          cartBloc?.add(CartDeleteButtonClicked(data.id));
                        },
                        onIncreaseButtonClicked: () {
                          cartBloc
                              ?.add(CartIncreaseCountButtonClicked(data.id));
                        },
                        onDecreaseButtonClicked: () {
                          if (data.count > 1) {
                            cartBloc
                                ?.add(CartDecreaseCountButtonClicked(data.id));
                          }
                        },
                      );
                    } else {
                      return PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          totalPrice: state.cartResponse.totalPrice,
                          shippingCost: state.cartResponse.shippingCost);
                    }
                  },
                  itemCount: state.cartResponse.cartItems.length + 1,
                ),
              );
            } else if (state is CartAuthRequired) {
              return EmptyView(
                  message:
                      'برای مشاهده سبد سفارش ابتدا وارد حساب کاربری خود شوید ',
                  callToAction: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: const AuthScreen())));
                      },
                      child: const Text("ورورد به حساب کاربری")),
                  image: SvgPicture.asset(
                    'assets/img/auth_required.svg',
                    width: 120,
                  ));
            } else if (state is CartEmpty) {
              return SmartRefresher(
                header: ClassicHeader(
                  completeText: "موفق",
                  refreshingText: 'در حال بروزرسانی',
                  idleText: 'برای بروزرسانی پایین بکشید',
                  releaseText: 'رها کنید',
                  failedText: "خطای نامشخص",
                  spacing: 2,
                  completeIcon:
                      Icon(CupertinoIcons.checkmark_circle, color: Colors.grey),
                ),
                controller: _refreshController,
                onRefresh: () {
                  cartBloc?.add(CartStarted(
                      AuthRepository.authChangeNotifier.value,
                      isRefreshing: true));
                },
                child: EmptyView(
                    message: 'هنوز سفارشی به سبد خود اضافه نکرده اید',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    )),
              );
            } else {
              throw Exception('current cart state is not valid');
            }
          }),
        )
        //  ValueListenableBuilder<AuthInfo?>(
        //   valueListenable: AuthRepository.authChangeNotifier,
        //   builder: (context, authState, child) {
        //     bool isAuthenticated =
        //         authState != null && authState.accessToken.isNotEmpty;
        //     return SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(isAuthenticated
        //               ? 'خوش آمدید'
        //               : 'لطفا وارد حساب کاربری خود شوید'),
        //           isAuthenticated
        //               ? ElevatedButton(
        //                   onPressed: () {
        //                     // authRepository.signOut();
        //                   },
        //                   child: const Text('خروج از حساب'))
        //               : ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.of(context, rootNavigator: true).push(
        //                         MaterialPageRoute(
        //                             builder: (context) => const AuthScreen()));
        //                   },
        //                   child: const Text('ورود')),
        //           ElevatedButton(
        //               onPressed: () async {
        //                 // await authRepository.refreshToken();
        //               },
        //               child: const Text('Refresh Token')),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
