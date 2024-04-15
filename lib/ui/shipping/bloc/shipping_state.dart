part of 'shipping_bloc.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

class ShippingShow extends ShippingState {
  final UserEntity info;

  const ShippingShow(this.info);

  @override
  List<Object> get props => [info];
}

class ShippingLoading extends ShippingState {}

class ShippingError extends ShippingState {
  final AppException appException;

  const ShippingError(this.appException);
  @override
  List<Object> get props => [appException];
}

class ShippingSuccess extends ShippingState {
  final CreateOrderResult result;

  const ShippingSuccess(this.result);

  @override
  List<Object> get props => [result];
}
