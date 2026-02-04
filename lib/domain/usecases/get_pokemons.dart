import '../entities/pokemon.dart';
import '../entities/pokemon_detail.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemonsFromApi({int offset = 0, int limit = 10});
  Future<List<Pokemon>> getPokemonsFromLocal();
  Future<void> savePokemons(List<Pokemon> pokemons);
  Future<PokemonDetail> getPokemonDetail(int id);
}

class GetPokemons {
  final PokemonRepository repository;

  GetPokemons(this.repository);

  Future<List<Pokemon>> execute({int page = 0}) async {
    const limit = 10;
    final offset = page * limit;
    
    try {
      List<Pokemon> pokemons = await repository.getPokemonsFromApi(offset: offset, limit: limit);
      // Note: We might want to append to local storage or handle caching strategy differently for pagination.
      // For now, we just save the latest chunk or consider how to merge.
      // Saving every chunk might behave unexpectedly if we just overwrite 'pokemons'.
      // For this step, we will ONLY return the list and not overwrite the cache blindly to avoid losing previous pages if we were to support offline pagination perfectly (which is complex).
      // Let's keep saving for the 'latest' cache but strictly speaking offline pagination requires a more robust DB structure.
      // We will skip savePokemons(pokemons) here for pagination chunks to avoid overwriting the full list with just 10 items.
      // Or we append. Let's simplifiy: Only cache the first page (dashboard).
      
      if (page == 0) {
         await repository.savePokemons(pokemons);
      }
      
      return pokemons;
    } catch (e) {
      // Logic for offline support on pagination is complex. 
      // If page 0 fails, we try local.
      if (page == 0) {
        return await repository.getPokemonsFromLocal(); 
      }
      throw e; // If loading more pages fails, we just throw to show error/snackbar
    }
  }
}

class GetPokemonDetail {
  final PokemonRepository repository;

  GetPokemonDetail(this.repository);

  Future<PokemonDetail> execute(int id) async {
    return await repository.getPokemonDetail(id);
  }
}
