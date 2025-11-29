import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class GetAddressForCep extends AddressEvent {
  final String cep;

  const GetAddressForCep(this.cep);

  @override
  List<Object> get props => [cep];
}

class ResetAddress extends AddressEvent {}
