import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/common/http_client.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/banner.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/repo/banner_repository.dart';
import 'package:shop_project/data/repo/product_repository.dart';
import 'package:shop_project/ui/home/bloc/home_bloc.dart';
import 'package:shop_project/ui/list/list.dart';
import 'package:shop_project/ui/product/product.dart';
import 'package:shop_project/ui/widgets/error.dart';
import 'package:shop_project/ui/widgets/image.dart';
import 'package:shop_project/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) {
      final homeBloc = HomeBloc(
        bannerRepository: bannerRepository,
        productRepository: productRepository,
      );
      homeBloc.add(HomeStarted());
      return homeBloc;
    }, child: Scaffold(
      //Listview:baraye load shudan hame satr ha
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              return ListView.builder(
                  physics: defaultScrollPhysics,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/img/woman_bag.png',
                            height: 28,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                      case 3:
                        return _HorizontalProductList(
                          title: 'جدیدترین',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                    sort: ProductSort.latest)));
                          },
                          products: state.latestProducts,
                        );
                      case 4:
                        return _HorizontalProductList(
                          title: 'پربازدیدترین',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                    sort: ProductSort.popular)));
                          },
                          products: state.popularProducts,
                        );
                      case 5:
                        return _HorizontalProductList(
                          title: 'آماده ارسال',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                    sort: ProductSort.ready)));
                          },
                          products: state.readyProducts,
                        );
                      default:
                        return Container();
                    }
                  });
            } else if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },
              );
            } else {
              throw "state is not supported";
            }
          },
        ),
      ),
    ));
  }
}

class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;
  const _HorizontalProductList({
    Key? key,
    required this.title,
    required this.onTap,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              TextButton(onPressed: onTap, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              physics: defaultScrollPhysics,
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 8, right: 8),
              itemBuilder: ((context, index) {
                // print("products : ${products}");

                final product = products[index];
                // print("product k mide b safe joziat : ${product}");
                // print(
                //   ((product.imageUrl).replaceAll(r'\', "/"))
                //       .replaceAll('uploads', 'http://10.0.2.2:3000/uploads'),
                // );
                return ProductItem(
                  product: product,
                  borderRadius: BorderRadius.circular(12),
                );
              })),
        )
      ],
    );
  }
}
