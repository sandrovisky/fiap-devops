import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  /// Busca endereço por CEP na API ViaCEP
  ///
  /// Throws [ServerException] para erros de servidor
  /// Throws [NetworkException] para erros de conexão
  Future<AddressModel> getAddressByCep(String cep);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final http.Client httpClient;

  AddressRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<AddressModel> getAddressByCep(String cep) async {
    try {
      final response = await httpClient.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // ViaCEP retorna {"erro": true} quando CEP não existe
        if (json['erro'] == true || json['erro'] == 'true') {
          throw ServerException('CEP não encontrado');
        }

        return AddressModel.fromJson(json);
      } else {
        throw ServerException('Erro ao buscar CEP: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Erro de conexão: ${e.toString()}');
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
