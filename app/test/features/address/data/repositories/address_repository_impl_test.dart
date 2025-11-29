import 'package:app/core/error/failures.dart';
import 'package:app/features/address/data/datasources/address_remote_data_source.dart';
import 'package:app/features/address/data/models/address_model.dart';
import 'package:app/features/address/data/repositories/address_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repository_impl_test.mocks.dart';

@GenerateMocks([AddressRemoteDataSource])
void main() {
  late AddressRepositoryImpl repository;
  late MockAddressRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAddressRemoteDataSource();
    repository = AddressRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tCep = '01310100';
  const tAddressModel = AddressModel(
    cep: '01310-100',
    logradouro: 'Avenida Paulista',
    complemento: 'até 610 - lado par',
    bairro: 'Bela Vista',
    localidade: 'São Paulo',
    uf: 'SP',
  );

  group('getAddressByCep', () {
    test(
      'deve retornar Address quando a chamada ao data source for bem-sucedida',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getAddressByCep(any),
        ).thenAnswer((_) async => tAddressModel);

        // act
        final result = await repository.getAddressByCep(tCep);

        // assert
        expect(result, equals(const Right(tAddressModel)));
        verify(mockRemoteDataSource.getAddressByCep(tCep));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'deve retornar ServerFailure quando o data source lançar ServerException',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getAddressByCep(any),
        ).thenThrow(ServerException('CEP não encontrado'));

        // act
        final result = await repository.getAddressByCep(tCep);

        // assert
        expect(result, equals(const Left(ServerFailure('CEP não encontrado'))));
        verify(mockRemoteDataSource.getAddressByCep(tCep));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'deve retornar NetworkFailure quando o data source lançar NetworkException',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getAddressByCep(any),
        ).thenThrow(NetworkException('Sem conexão'));

        // act
        final result = await repository.getAddressByCep(tCep);

        // assert
        expect(result, equals(const Left(NetworkFailure('Sem conexão'))));
        verify(mockRemoteDataSource.getAddressByCep(tCep));
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'deve retornar ServerFailure quando ocorrer um erro inesperado',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getAddressByCep(any),
        ).thenThrow(Exception('Erro inesperado'));

        // act
        final result = await repository.getAddressByCep(tCep);

        // assert
        expect(result, isA<Left>());
        expect(
          (result as Left).value,
          isA<ServerFailure>().having(
            (f) => f.message,
            'message',
            contains('Erro inesperado'),
          ),
        );
        verify(mockRemoteDataSource.getAddressByCep(tCep));
      },
    );
  });
}
