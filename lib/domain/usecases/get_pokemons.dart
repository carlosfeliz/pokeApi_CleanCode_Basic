import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getPokemonsFromApi();
  Future<List<Pokemon>> getPokemonsFromLocal();
  Future<void> savePokemons(List<Pokemon> pokemons);
}

class GetPokemons {
  final PokemonRepository repository;

  GetPokemons(this.repository);

  Future<List<Pokemon>> execute() async {
    try {
      List<Pokemon> pokemons = await repository.getPokemonsFromApi();
      await repository.savePokemons(pokemons); // Guarda los Pokémones localmente
      return pokemons;
    } catch (e) {
      return await repository.getPokemonsFromLocal(); // Cargar desde local si falla
    }
  }
}
