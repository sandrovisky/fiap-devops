import 'package:app/features/address/data/models/address_model.dart';
import 'package:app/features/address/domain/entities/address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tAddressModel = AddressModel(
    cep: '01310-100',
    logradouro: 'Avenida Paulista',
    complemento: 'até 610 - lado par',
    bairro: 'Bela Vista',
    localidade: 'São Paulo',
    uf: 'SP',
  );

  test('deve ser uma subclasse de Address entity', () async {
    // assert
    expect(tAddressModel, isA<Address>());
  });

  group('fromJson', () {
    test(
      'deve retornar um AddressModel válido quando o JSON está correto',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'cep': '01310-100',
          'logradouro': 'Avenida Paulista',
          'complemento': 'até 610 - lado par',
          'bairro': 'Bela Vista',
          'localidade': 'São Paulo',
          'uf': 'SP',
        };

        // act
        final result = AddressModel.fromJson(jsonMap);

        // assert
        expect(result, tAddressModel);
      },
    );

    test('deve retornar strings vazias para campos ausentes', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        'cep': '01310-100',
        'logradouro': 'Avenida Paulista',
      };

      // act
      final result = AddressModel.fromJson(jsonMap);

      // assert
      expect(result.complemento, '');
      expect(result.bairro, '');
      expect(result.localidade, '');
      expect(result.uf, '');
    });
  });

  group('toJson', () {
    test('deve retornar um JSON map contendo os dados corretos', () async {
      // act
      final result = tAddressModel.toJson();

      // assert
      final expectedMap = {
        'cep': '01310-100',
        'logradouro': 'Avenida Paulista',
        'complemento': 'até 610 - lado par',
        'bairro': 'Bela Vista',
        'localidade': 'São Paulo',
        'uf': 'SP',
      };
      expect(result, expectedMap);
    });
  });
}
