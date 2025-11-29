import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/address/data/datasources/address_remote_data_source.dart';
import 'features/address/data/repositories/address_repository_impl.dart';
import 'features/address/domain/repositories/address_repository.dart';
import 'features/address/domain/usecases/get_address_by_cep.dart';
import 'features/address/presentation/bloc/address_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Features - Address
  // Bloc
  getIt.registerFactory(() => AddressBloc(getAddressByCep: getIt()));

  // Use cases
  getIt.registerLazySingleton(() => GetAddressByCep(getIt()));

  // Repository
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(remoteDataSource: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(httpClient: getIt()),
  );

  // External
  getIt.registerLazySingleton(() => http.Client());
}
