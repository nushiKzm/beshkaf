import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_project/common/exceptions.dart';
import 'package:shop_project/data/banner.dart';
import 'package:shop_project/data/product.dart';
import 'package:shop_project/data/repo/banner_repository.dart';
import 'package:shop_project/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;

  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading()); //baraye refresh
          //baraye bar aval equatable az rebuild shudan bad az 2 state yeksan jologiri mikonad
          final banners = await bannerRepository.getAll();
          final latestProducts =
              await productRepository.getAll(ProductSort.latest);
          final popularProducts =
              await productRepository.getAll(ProductSort.popular);
          final readyProducts =
              await productRepository.getAll(ProductSort.ready);
          emit(HomeSuccess(
              banners: banners,
              latestProducts: latestProducts,
              popularProducts: popularProducts,
              readyProducts: readyProducts));
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
          //dar sorat vojod e yani khatta haman khatta http req ast.
        }
      }
    });
  }
}
