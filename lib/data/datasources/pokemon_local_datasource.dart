import 'package:hive/hive.dart';
import '../../../domain/entities/pokemon.dart';

class PokemonLocalDataSource {
  Future<void> cachePokemons(List<Pokemon> pokemons) async {
    final box = await Hive.openBox('pokemonsBox');
    // Convert List<Pokemon> to List<Map>
    final List<Map<String, dynamic>> jsonList = pokemons.map((p) => p.toMap()).toList();
    await box.put('pokemons', jsonList);
  }

  Future<List<Pokemon>> getCachedPokemons() async {
    final box = await Hive.openBox('pokemonsBox');
    final dynamic data = box.get('pokemons');
    
    if (data != null && data is List) {
       // Convert List<dynamic> (which are Maps) back to List<Pokemon>
       return data.map((e) => Pokemon.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    
    return [];
  }
}
