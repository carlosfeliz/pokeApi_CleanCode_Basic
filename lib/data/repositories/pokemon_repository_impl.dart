import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_pokemons.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';


class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<Pokemon>> getPokemonsFromApi() async {
    return await remoteDataSource.fetchPokemons();
  }

  @override
  Future<List<Pokemon>> getPokemonsFromLocal() async {
    return await localDataSource.getCachedPokemons();
  }

  @override
  Future<void> savePokemons(List<Pokemon> pokemons) async {
    await localDataSource.cachePokemons(pokemons);
  }
}
