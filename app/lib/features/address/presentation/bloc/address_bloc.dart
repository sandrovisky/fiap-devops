import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_address_by_cep.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressByCep getAddressByCep;

  AddressBloc({required this.getAddressByCep}) : super(AddressInitial()) {
    on<GetAddressForCep>(_onGetAddressForCep);
    on<ResetAddress>(_onResetAddress);
  }

  Future<void> _onGetAddressForCep(
    GetAddressForCep event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await getAddressByCep(event.cep);

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (address) => emit(AddressLoaded(address)),
    );
  }

  void _onResetAddress(ResetAddress event, Emitter<AddressState> emit) {
    emit(AddressInitial());
  }
}
