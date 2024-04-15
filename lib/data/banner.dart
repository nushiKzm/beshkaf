class BannerEntity {
  final String id;
  final String imageUrl;

  BannerEntity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        imageUrl = json['image'];
}
