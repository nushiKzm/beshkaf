part of 'shipping_bloc.dart';

abstract class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

class ShippingStarted extends ShippingEvent {}

class ShippingCreateOrder extends ShippingEvent {
  final CreateOrderParams params;

  const ShippingCreateOrder(this.params);
}
