import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_product_details.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetails getProductDetails;

  ProductDetailBloc({required this.getProductDetails})
    : super(const ProductDetailState.initial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<RefreshProductDetail>(_onRefreshProductDetail);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailState.loading());

    final result = await getProductDetails(event.productId);

    result.fold(
      (failure) {
        emit(ProductDetailState.failure(failure.message));
      },
      (product) {
        emit(ProductDetailState.success(product));
      },
    );
  }

  Future<void> _onRefreshProductDetail(
    RefreshProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    final result = await getProductDetails(event.productId);

    result.fold(
      (failure) {
        emit(ProductDetailState.failure(failure.message));
      },
      (product) {
        emit(ProductDetailState.success(product));
      },
    );
  }
}
