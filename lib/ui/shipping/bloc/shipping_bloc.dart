import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/data/order.dart';
import 'package:shop_project/data/repo/cart_repository.dart';
import 'package:shop_project/data/repo/order_repository.dart';
import 'package:shop_project/data/user.dart';
import 'package:shop_project/ui/widgets/error.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository repository;
  ShippingBloc(this.repository) : super(ShippingLoading()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        try {
          emit(ShippingLoading());
          final result = await repository.create(event.params);
          CartRepository.cartItemCountNotifier.value = 0;
          emit(ShippingSuccess(result));
        } catch (e) {
          emit(ShippingError(AppException()));
        }
      } else if (event is ShippingStarted) {
        emit(ShippingLoading());
        final info = await repository.getUserInfo();
        emit(ShippingShow(info));
      }
    });
  }
}
