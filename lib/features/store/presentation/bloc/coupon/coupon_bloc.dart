import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_coupon.dart';
import 'coupon_event.dart';
import 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final GetCoupons getCoupons;

  CouponBloc({required this.getCoupons}) : super(const CouponState()) {
    on<LoadCoupons>(_onLoadCoupons);
  }

  Future<void> _onLoadCoupons(
    LoadCoupons event,
    Emitter<CouponState> emit,
  ) async {
    emit(state.copyWith(status: CouponStatus.loading));
    final result = await getCoupons();

    result.fold(
      (failure) => emit(state.copyWith(status: CouponStatus.failure,errorMessage: failure.message)),
      (coupons) => emit(state.copyWith(status: CouponStatus.success,coupons: coupons)),
    );
  }
}