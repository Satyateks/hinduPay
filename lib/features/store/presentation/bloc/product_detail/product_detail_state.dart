import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_details.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductDetail? product;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage,
  });

  const ProductDetailState.initial()
    : status = ProductDetailStatus.initial,
      product = null,
      errorMessage = null;

  const ProductDetailState.loading()
    : status = ProductDetailStatus.loading,
      product = null,
      errorMessage = null;

  const ProductDetailState.success(ProductDetail data)
    : status = ProductDetailStatus.success,
      product = data,
      errorMessage = null;

  const ProductDetailState.failure(String message)
    : status = ProductDetailStatus.failure,
      product = null,
      errorMessage = message;

  @override
  List<Object?> get props => [status, product, errorMessage];
}
