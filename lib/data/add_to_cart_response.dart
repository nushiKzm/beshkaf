class AddToCartResponse {
  final String productId;
  final String cartItemId;
  final int count;

  AddToCartResponse(this.productId, this.cartItemId, this.count);

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['_id'],
        count = json['count'];
}
