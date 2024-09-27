import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'data/datasources/pokemon_local_datasource.dart';
import 'data/datasources/pokemon_remote_datasource.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'domain/usecases/get_pokemons.dart';
import 'presentation/bloc/pokemon_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Inyección del cliente HTTP Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Inyección de DataSources
  getIt.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSource(),
  );

  // Inyección del repositorio
  getIt.registerLazySingleton<PokemonRepositoryImpl>(
    () => PokemonRepositoryImpl(
      getIt<PokemonRemoteDataSource>(),
      getIt<PokemonLocalDataSource>(),
    ),
  );

  // Inyección del caso de uso
  getIt.registerLazySingleton<GetPokemons>(
    () => GetPokemons(getIt<PokemonRepositoryImpl>()),
  );

  // Inyección del Cubit (manejador de estado)
  getIt.registerFactory(() => PokemonCubit(getIt<GetPokemons>()));
}
