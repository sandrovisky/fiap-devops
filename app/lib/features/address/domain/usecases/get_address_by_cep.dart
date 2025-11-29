import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetAddressByCep implements UseCase<Address, String> {
  final AddressRepository repository;

  GetAddressByCep(this.repository);

  @override
  Future<Either<Failure, Address>> call(String cep) async {
    // Remove caracteres não numéricos
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');

    // Valida formato do CEP
    if (cleanCep.length != 8) {
      return const Left(InvalidCepFailure('CEP deve conter 8 dígitos'));
    }

    return await repository.getAddressByCep(cleanCep);
  }
}
