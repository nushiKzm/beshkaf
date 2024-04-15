import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/favorite_manager.dart';
import 'package:shop_project/theme.dart';
import 'package:shop_project/ui/product/details.dart';
import 'package:shop_project/ui/widgets/image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لیست علاقه مندی ها')),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManager.listenable,
        builder: (BuildContext context, value, Widget? child) {
          final products = value.values.toList();
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: products[index])));
                  },
                  onLongPress: () {
                    favoriteManager.deleteFavorite(products[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: ImageLoadingService(
                              imageUrl: ((products[index].imageUrl)
                                      .replaceAll(r'\', "/"))
                                  .replaceAll(
                                      'uploads', 'http://10.0.2.2:3000'),
                              borderRadius: BorderRadius.circular(8),
                            )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[index].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .apply(
                                          color: LightThemeColors
                                              .primaryTextColor)),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                products[index].previousPrice.withPriceLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .apply(
                                        decoration: TextDecoration.lineThrough),
                              ),
                              Text(products[index].price.withPriceLabel)
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
