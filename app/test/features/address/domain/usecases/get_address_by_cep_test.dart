import 'package:app/core/error/failures.dart';
import 'package:app/features/address/domain/entities/address.dart';
import 'package:app/features/address/domain/repositories/address_repository.dart';
import 'package:app/features/address/domain/usecases/get_address_by_cep.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_address_by_cep_test.mocks.dart';

@GenerateMocks([AddressRepository])
void main() {
  late GetAddressByCep usecase;
  late MockAddressRepository mockAddressRepository;

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    usecase = GetAddressByCep(mockAddressRepository);
  });

  const tCep = '01310100';
  const tAddress = Address(
    cep: '01310-100',
    logradouro: 'Avenida Paulista',
    complemento: 'até 610 - lado par',
    bairro: 'Bela Vista',
    localidade: 'São Paulo',
    uf: 'SP',
  );

  test('deve buscar endereço pelo CEP do repositório', () async {
    // arrange
    when(
      mockAddressRepository.getAddressByCep(any),
    ).thenAnswer((_) async => const Right(tAddress));

    // act
    final result = await usecase(tCep);

    // assert
    expect(result, const Right(tAddress));
    verify(mockAddressRepository.getAddressByCep(tCep));
    verifyNoMoreInteractions(mockAddressRepository);
  });

  test('deve limpar caracteres não numéricos do CEP', () async {
    // arrange
    when(
      mockAddressRepository.getAddressByCep(any),
    ).thenAnswer((_) async => const Right(tAddress));

    // act
    final result = await usecase('01310-100');

    // assert
    expect(result, const Right(tAddress));
    verify(mockAddressRepository.getAddressByCep(tCep));
  });

  test(
    'deve retornar InvalidCepFailure quando CEP tem menos de 8 dígitos',
    () async {
      // act
      final result = await usecase('123');

      // assert
      expect(
        result,
        const Left(InvalidCepFailure('CEP deve conter 8 dígitos')),
      );
      verifyZeroInteractions(mockAddressRepository);
    },
  );

  test(
    'deve retornar InvalidCepFailure quando CEP tem mais de 8 dígitos',
    () async {
      // act
      final result = await usecase('123456789');

      // assert
      expect(
        result,
        const Left(InvalidCepFailure('CEP deve conter 8 dígitos')),
      );
      verifyZeroInteractions(mockAddressRepository);
    },
  );

  test('deve retornar Failure quando o repositório retorna erro', () async {
    // arrange
    when(
      mockAddressRepository.getAddressByCep(any),
    ).thenAnswer((_) async => const Left(ServerFailure('Erro no servidor')));

    // act
    final result = await usecase(tCep);

    // assert
    expect(result, const Left(ServerFailure('Erro no servidor')));
    verify(mockAddressRepository.getAddressByCep(tCep));
  });
}
