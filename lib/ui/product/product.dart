import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_project/common/utils.dart';
import 'package:shop_project/data/favorite_manager.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/ui/product/details.dart';
import 'package:shop_project/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemHeight = 189,
  }) : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;

  final double itemWidth;
  final double itemHeight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(product: widget.product))),
          child: SizedBox(
            width: widget.itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLoadingService(
                        imageUrl:
                            ((widget.product.imageUrl).replaceAll(r'\', "/"))
                                .replaceAll('uploads', 'http://10.0.2.2:3000'),
                        borderRadius: widget.borderRadius,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: InkWell(
                        onTap: () {
                          if (!favoriteManager.isFavorites(widget.product)) {
                            favoriteManager.addFavorite(widget.product);
                          } else {
                            favoriteManager.deleteFavorite(widget.product);
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                              favoriteManager.isFavorites(widget.product)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: 20),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title,
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Text(
                    widget.product.previousPrice.withPriceLabel,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Text(widget.product.price.withPriceLabel),
                ),
              ],
            ),
          ),
        ));
  }
}
