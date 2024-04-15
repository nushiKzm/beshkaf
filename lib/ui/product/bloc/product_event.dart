part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CartAddButtonClick extends ProductEvent {
  final String productId;

  const CartAddButtonClick(this.productId);
}
