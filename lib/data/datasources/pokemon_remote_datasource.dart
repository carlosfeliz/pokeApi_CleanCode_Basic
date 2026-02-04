import 'package:dio/dio.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_detail.dart';

class PokemonRemoteDataSource {
  final Dio client;

  PokemonRemoteDataSource(this.client);

  Future<List<Pokemon>> fetchPokemons({int offset = 0, int limit = 10}) async {
    try {
      final response = await client.get('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');

      // Extraemos la lista de resultados del JSON
      final List<dynamic> results = response.data['results'];

      // Convertimos los datos a una lista de Pokémones
      return results.map((pokemonData) {
        final String url = pokemonData['url'];
        final String name = pokemonData['name'];

        // Extraemos el ID del Pokémon desde la URL
        final int id = int.parse(url.split('/').where((element) => element.isNotEmpty).last);

        // Construimos la URL de la imagen del Pokémon
        final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

        return Pokemon(id: id, name: name, imageUrl: imageUrl);
      }).toList();
    } catch (error) {
      throw Exception('Error fetching pokemons: $error');
    }
  }
  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    try {
      final response = await client.get('https://pokeapi.co/api/v2/pokemon/$id');
      final data = response.data;

      // Fetch Species to get Evolution Chain URL
      final speciesResponse = await client.get(data['species']['url']);
      final evolutionChainUrl = speciesResponse.data['evolution_chain']['url'];

      // Fetch Evolution Chain
      final evolutionResponse = await client.get(evolutionChainUrl);
      final evolutionData = evolutionResponse.data['chain'];

      List<Map<String, dynamic>> evolutions = [];
      _parseEvolutionChain(evolutionData, evolutions);

      return PokemonDetail(
        id: data['id'],
        name: data['name'],
        imageUrl: data['sprites']['other']['official-artwork']['front_default'] ?? 
                 data['sprites']['front_default'],
        height: data['height'],
        weight: data['weight'],
        types: (data['types'] as List)
            .map((t) => t['type']['name'] as String)
            .toList(),
        stats: {
          for (var s in (data['stats'] as List))
            s['stat']['name'] as String: s['base_stat'] as int
        },
        evolutions: evolutions,
      );
    } catch (error) {
      throw Exception('Error fetching pokemon detail: $error');
    }
  }

  void _parseEvolutionChain(Map<String, dynamic> chainData, List<Map<String, dynamic>> evolutions) {
     final species = chainData['species'];
     final String name = species['name'];
     final String url = species['url'];
     final int id = int.parse(url.split('/').where((e) => e.isNotEmpty).last);
     final String imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

     evolutions.add({
       'id': id,
       'name': name,
       'imageUrl': imageUrl,
     });

     if (chainData['evolves_to'] != null && (chainData['evolves_to'] as List).isNotEmpty) {
       for (var nextEvolution in chainData['evolves_to']) {
         _parseEvolutionChain(nextEvolution, evolutions);
       }
     }
  }
}
