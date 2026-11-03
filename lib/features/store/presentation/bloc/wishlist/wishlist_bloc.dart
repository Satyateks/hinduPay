import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;

  WishlistBloc({
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
  }) : super(const WishlistState()) {
    on<LoadWishlist>(_onLoad);
    on<AddWishlistItem>(_onAdd);
    on<RemoveWishlistItem>(_onRemove);
  }

  Future<void> _onLoad(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(const WishlistState(status: WishlistStatus.loading));
    final result = await getWishlist();

    result.fold(
      (failure) => emit(
        WishlistState(
          status: WishlistStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        WishlistState(
          status: WishlistStatus.success,
          items: items,
        ),
      ),
    );
  }

  Future<void> _onAdd(
    AddWishlistItem event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistState(
      status: WishlistStatus.updating,
      items: state.items,
    ));

    final result = await addToWishlist(event.item);

    await result.fold<Future<void>>(
      (failure) async {
        emit(WishlistState(
          status: WishlistStatus.failure,
          items: state.items,
          errorMessage: failure.message,
        ));
      },
      (_) async {
        final updated = await getWishlist();

        updated.fold(
          (failure) => emit(WishlistState(
            status: WishlistStatus.failure,
            items: state.items,
            errorMessage: failure.message,
          )),
          (items) => emit(WishlistState(
            status: WishlistStatus.success,
            items: items,
          )),
        );
      },
    );
  }

  Future<void> _onRemove(
    RemoveWishlistItem event,
    Emitter<WishlistState> emit,
  ) async {
    final previousItems = state.items;

    emit(WishlistState(
      status: WishlistStatus.updating,
      items: previousItems,
    ));

    final result = await removeFromWishlist(event.productId);

    await result.fold<Future<void>>(
      (failure) async {
        emit(WishlistState(
          status: WishlistStatus.failure,
          items: previousItems,
          errorMessage: failure.message,
        ));
      },
      (_) async {
        final updated = await getWishlist();

        updated.fold(
          (failure) => emit(WishlistState(
            status: WishlistStatus.failure,
            items: previousItems,
            errorMessage: failure.message,
          )),
          (items) => emit(WishlistState(status: WishlistStatus.success, items: items)),
        );
      },
    );
  }
}