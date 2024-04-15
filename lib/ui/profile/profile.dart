import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_project/data/auth_info.dart';
import 'package:shop_project/ui/auth/auth.dart';
import 'package:shop_project/ui/favorites/favoritesScreen.dart';
import 'package:shop_project/ui/order/order_history_screen.dart';
import 'package:shop_project/ui/profile/profile_info.dart';
// import 'package:shop_project/ui/favorites/favoritesScreen.dart';

import '../../data/repo/auth_repository.dart';
import '../../data/repo/cart_repository.dart';

class profileScreen extends StatelessWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(''),
      //   // actions: [
      //   //   IconButton(
      //   //       onPressed: () {
      //   //         CartRepository.cartItemCountNotifier.value = 0;
      //   //         authRepository.signOut();
      //   //       },
      //   //       icon: Icon(Icons.exit_to_app))
      //   // ],
      // ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(left: 8, top: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1, color: Theme.of(context).dividerColor),
                      ),
                      child: Image.asset('assets/img/beuty_woman.png'),
                    ),
                    Text(isLogin ? authInfo.userName : 'کاربر مهمان'),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        final String accessToken =
                            sharedPreferences.getString("access_token") ?? '';
                        if (accessToken != '') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileInfoScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('ابتدا وارد حساب کاربری خود شوید')));
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: const [
                            Icon(CupertinoIcons.profile_circled),
                            SizedBox(
                              width: 10,
                            ),
                            Text('پروفایل')
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        final String accessToken =
                            sharedPreferences.getString("access_token") ?? '';
                        if (accessToken != '') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FavoritesScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('ابتدا وارد حساب کاربری خود شوید')));
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: const [
                            Icon(CupertinoIcons.heart),
                            SizedBox(
                              width: 10,
                            ),
                            Text('لیست علاقه مندی ها')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        final String accessToken =
                            sharedPreferences.getString("access_token") ?? '';
                        if (accessToken != '') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrderHistoryScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('ابتدا وارد حساب کاربری خود شوید')));
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: const [
                            Icon(CupertinoIcons.cart),
                            SizedBox(
                              width: 10,
                            ),
                            Text('سوابق پرداخت')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () {
                        if (isLogin) {
                          showDialog(
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('خروج از حساب کاربری'),
                                    content: const Text(
                                        'آیا میخواهید از حساب خود خارج شوید؟'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('خیر')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            CartRepository.cartItemCountNotifier
                                                .value = 0;
                                            authRepository.signOut();
                                          },
                                          child: const Text('بله')),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: const AuthScreen())));
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            Icon(isLogin
                                ? CupertinoIcons.arrow_right_square
                                : CupertinoIcons.arrow_left_square),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(isLogin
                                ? 'خروج از حساب کاریری'
                                : 'ورود به حساب کاربری'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                    )
                  ]),
            );
          }),
    );
  }
}
