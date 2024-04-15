import 'package:hive_flutter/adapters.dart';
part 'product.g.dart';

class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;
  static const int ready = 4;

  static const List<String> names = [
    'جدیدترین',
    'پربازدیدترین',
    'گران به ارزان ',
    ' ارزان تا گران',
    'آماده ارسال'
  ];
}

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int previousPrice;
  @HiveField(5)
  final String description;
  // final int discount;
  ProductEntity(this.id, this.title, this.imageUrl, this.price,
      this.previousPrice, this.description);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        imageUrl = json['image'],
        description = json['description'],
        price = json['price'],
        previousPrice = json['previous_price'] ?? json['price'];
  // discount = json['discount'];
}