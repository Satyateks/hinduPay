import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/address_remote_datasource.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository repository;

  AddressBloc({required this.repository}) : super(const AddressState()) {
    on<LoadAddresses>((event, emit) async {
      emit(
        AddressState(status: AddressStatus.loading, addresses: state.addresses),
      );

      final result = await repository.getAddresses();
      result.fold(
        (failure) => emit(
          AddressState(
            status: AddressStatus.failure,
            addresses: state.addresses,
            errorMessage: failure.message,
          ),
        ),
        (addresses) => emit(
          AddressState(status: AddressStatus.success, addresses: addresses),
        ),
      );
    });

    on<AddAddressRequested>((event, emit) async {
      emit(
        AddressState(status: AddressStatus.saving, addresses: state.addresses),
      );

      final result = await repository.addAddress(event.address);
      await _reloadAfterMutation(result, emit);
    });

    on<UpdateAddressRequested>((event, emit) async {
      emit(
        AddressState(status: AddressStatus.saving, addresses: state.addresses),
      );

      final result = await repository.updateAddress(event.address);
      await _reloadAfterMutation(result, emit);
    });

    on<DeleteAddressRequested>((event, emit) async {
      final result = await repository.deleteAddress(event.id);

      await result.fold(
        (failure) async {
          emit(
            AddressState(
              status: AddressStatus.failure,
              addresses: state.addresses,
              errorMessage: failure.message,
            ),
          );
        },
        (_) async {
          final refreshed = await repository.getAddresses();
          refreshed.fold(
            (failure) => emit(
              AddressState(
                status: AddressStatus.failure,
                addresses: state.addresses,
                errorMessage: failure.message,
              ),
            ),
            (addresses) => emit(
              AddressState(status: AddressStatus.success, addresses: addresses),
            ),
          );
        },
      );
    });

    on<SelectAddressRequested>((event, emit) async {
      final result = await repository.selectAddress(event.id);

      await result.fold(
        (failure) async {
          emit(
            AddressState(
              status: AddressStatus.failure,
              addresses: state.addresses,
              errorMessage: failure.message,
            ),
          );
        },
        (_) async {
          final refreshed = await repository.getAddresses();
          refreshed.fold(
            (failure) => emit(
              AddressState(
                status: AddressStatus.failure,
                addresses: state.addresses,
                errorMessage: failure.message,
              ),
            ),
            (addresses) => emit(
              AddressState(status: AddressStatus.success, addresses: addresses),
            ),
          );
        },
      );
    });
  }

  Future<void> _reloadAfterMutation(
    dynamic result,
    Emitter<AddressState> emit,
  ) async {
    await result.fold(
      (failure) async {
        emit(
          AddressState(
            status: AddressStatus.failure,
            addresses: state.addresses,
            errorMessage: failure.message,
          ),
        );
      },
      (_) async {
        final refreshed = await repository.getAddresses();
        refreshed.fold(
          (failure) => emit(
            AddressState(
              status: AddressStatus.failure,
              addresses: state.addresses,
              errorMessage: failure.message,
            ),
          ),
          (addresses) => emit(
            AddressState(status: AddressStatus.success, addresses: addresses),
          ),
        );
      },
    );
  }
}
