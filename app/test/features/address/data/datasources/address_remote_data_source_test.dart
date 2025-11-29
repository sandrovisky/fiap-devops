import 'dart:convert';

import 'package:app/features/address/data/datasources/address_remote_data_source.dart';
import 'package:app/features/address/data/models/address_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AddressRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = AddressRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  const tCep = '01310100';

  group('getAddressByCep', () {
    final tAddressModel = AddressModel(
      cep: '01310-100',
      logradouro: 'Avenida Paulista',
      complemento: 'até 610 - lado par',
      bairro: 'Bela Vista',
      localidade: 'São Paulo',
      uf: 'SP',
    );

    test('deve realizar uma chamada GET para a URL correta', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'cep': '01310-100',
            'logradouro': 'Avenida Paulista',
            'complemento': 'até 610 - lado par',
            'bairro': 'Bela Vista',
            'localidade': 'São Paulo',
            'uf': 'SP',
          }),
          200,
        ),
      );

      // act
      await dataSource.getAddressByCep(tCep);

      // assert
      verify(
        mockHttpClient.get(Uri.parse('https://viacep.com.br/ws/$tCep/json/')),
      );
    });

    test(
      'deve retornar AddressModel quando o código de resposta for 200',
      () async {
        // arrange
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'cep': '01310-100',
              'logradouro': 'Avenida Paulista',
              'complemento': 'até 610 - lado par',
              'bairro': 'Bela Vista',
              'localidade': 'São Paulo',
              'uf': 'SP',
            }),
            200,
          ),
        );

        // act
        final result = await dataSource.getAddressByCep(tCep);

        // assert
        expect(result, equals(tAddressModel));
      },
    );

    test(
      'deve lançar ServerException quando o CEP não for encontrado',
      () async {
        // arrange
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(jsonEncode({'erro': true}), 200),
        );

        // act
        final call = dataSource.getAddressByCep;

        // assert
        expect(() => call(tCep), throwsA(isA<ServerException>()));
      },
    );

    test(
      'deve lançar ServerException quando o código de resposta não for 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(any),
        ).thenAnswer((_) async => http.Response('Algo deu errado', 404));

        // act
        final call = dataSource.getAddressByCep;

        // assert
        expect(() => call(tCep), throwsA(isA<ServerException>()));
      },
    );

    test(
      'deve lançar NetworkException quando houver erro de conexão',
      () async {
        // arrange
        when(
          mockHttpClient.get(any),
        ).thenThrow(Exception('Sem conexão com a internet'));

        // act
        final call = dataSource.getAddressByCep;

        // assert
        expect(() => call(tCep), throwsA(isA<NetworkException>()));
      },
    );
  });
}
