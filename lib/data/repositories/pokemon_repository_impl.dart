import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../../domain/usecases/get_pokemons.dart';
import '../datasources/pokemon_local_datasource.dart';
import '../datasources/pokemon_remote_datasource.dart';


class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<Pokemon>> getPokemonsFromApi({int offset = 0, int limit = 10}) async {
    return await remoteDataSource.fetchPokemons(offset: offset, limit: limit);
  }

  @override
  Future<List<Pokemon>> getPokemonsFromLocal() async {
    return await localDataSource.getCachedPokemons();
  }

  @override
  Future<void> savePokemons(List<Pokemon> pokemons) async {
    await localDataSource.cachePokemons(pokemons);
  }

  @override
  Future<PokemonDetail> getPokemonDetail(int id) async {
    return await remoteDataSource.fetchPokemonDetail(id);
  }
}
