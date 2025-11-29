import 'package:app/core/error/failures.dart';
import 'package:app/features/address/domain/entities/address.dart';
import 'package:app/features/address/domain/usecases/get_address_by_cep.dart';
import 'package:app/features/address/presentation/bloc/address_bloc.dart';
import 'package:app/features/address/presentation/bloc/address_event.dart';
import 'package:app/features/address/presentation/bloc/address_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_bloc_test.mocks.dart';

@GenerateMocks([GetAddressByCep])
void main() {
  late AddressBloc bloc;
  late MockGetAddressByCep mockGetAddressByCep;

  setUp(() {
    mockGetAddressByCep = MockGetAddressByCep();
    bloc = AddressBloc(getAddressByCep: mockGetAddressByCep);
  });

  test('estado inicial deve ser AddressInitial', () {
    expect(bloc.state, equals(AddressInitial()));
  });

  group('GetAddressForCep', () {
    const tCep = '01310100';
    const tAddress = Address(
      cep: '01310-100',
      logradouro: 'Avenida Paulista',
      complemento: 'até 610 - lado par',
      bairro: 'Bela Vista',
      localidade: 'São Paulo',
      uf: 'SP',
    );

    blocTest<AddressBloc, AddressState>(
      'deve emitir [AddressLoading, AddressLoaded] quando busca for bem-sucedida',
      build: () {
        when(
          mockGetAddressByCep(any),
        ).thenAnswer((_) async => const Right(tAddress));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetAddressForCep(tCep)),
      expect: () => [AddressLoading(), const AddressLoaded(tAddress)],
      verify: (_) {
        verify(mockGetAddressByCep(tCep));
      },
    );

    blocTest<AddressBloc, AddressState>(
      'deve emitir [AddressLoading, AddressError] quando busca falhar',
      build: () {
        when(mockGetAddressByCep(any)).thenAnswer(
          (_) async => const Left(ServerFailure('Erro no servidor')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetAddressForCep(tCep)),
      expect: () => [AddressLoading(), const AddressError('Erro no servidor')],
      verify: (_) {
        verify(mockGetAddressByCep(tCep));
      },
    );

    blocTest<AddressBloc, AddressState>(
      'deve emitir [AddressLoading, AddressError] para CEP inválido',
      build: () {
        when(mockGetAddressByCep(any)).thenAnswer(
          (_) async =>
              const Left(InvalidCepFailure('CEP deve conter 8 dígitos')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetAddressForCep('123')),
      expect: () => [
        AddressLoading(),
        const AddressError('CEP deve conter 8 dígitos'),
      ],
    );
  });

  group('ResetAddress', () {
    blocTest<AddressBloc, AddressState>(
      'deve emitir [AddressInitial] quando ResetAddress for chamado',
      build: () => bloc,
      seed: () => const AddressError('Erro'),
      act: (bloc) => bloc.add(ResetAddress()),
      expect: () => [AddressInitial()],
    );
  });
}
