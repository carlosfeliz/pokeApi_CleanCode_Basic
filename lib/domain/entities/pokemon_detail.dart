class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> types;
  final Map<String, int> stats; // e.g. {'hp': 50, 'attack': 80}
  final List<Map<String, dynamic>> evolutions; // List of {name, imageUrl, id}

  PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
    this.evolutions = const [],
  });
}
