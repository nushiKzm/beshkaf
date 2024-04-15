part of 'cart_bloc.dart';

abstract class CartState {
  const CartState();

  // @override
  // List<Object?> get props => [];
  //equatable va props haro hazf kardim k beshe bad az hazf yek item safe baz rebuild she
}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponse cartResponse;

  const CartSuccess(this.cartResponse);

// که هر موقع تغییری در کارت ریسپانس اتفاق افتاد باعث ریبیلد شدن بشه
  // @override
  // // TODO: implement props
  // List<Object?> get props => [cartResponse];
}

class CartError extends CartState {
  final AppException exception;

  const CartError(this.exception);
}

class CartEmpty extends CartState {}

class CartAuthRequired extends CartState {}
