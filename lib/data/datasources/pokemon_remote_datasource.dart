import 'package:dio/dio.dart';
import '../../domain/entities/pokemon.dart';

class PokemonRemoteDataSource {
  final Dio client;

  PokemonRemoteDataSource(this.client);

  Future<List<Pokemon>> fetchPokemons() async {
    try {
      final response = await client.get('https://pokeapi.co/api/v2/pokemon?limit=20');

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
}
