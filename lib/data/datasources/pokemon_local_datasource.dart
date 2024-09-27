import 'package:hive/hive.dart';
import '../../../domain/entities/pokemon.dart';

class PokemonLocalDataSource {
  Future<void> cachePokemons(List<Pokemon> pokemons) async {
    final box = await Hive.openBox<Pokemon>('pokemonsBox');
    await box.put('pokemons', pokemons as Pokemon);
  }

  Future<List<Pokemon>> getCachedPokemons() async {
    final box = await Hive.openBox<Pokemon>('pokemonsBox');
    final List<Pokemon>? cachedPokemons = box.get('pokemons') as List<Pokemon>?;
    return cachedPokemons ?? [];
  }
}
