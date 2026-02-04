import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../bloc/pokemon_detail_cubit.dart';
import '../../injection.dart' as di;

class PokemonDetailPage extends StatefulWidget {
  final int pokemonId;

  const PokemonDetailPage({super.key, required this.pokemonId});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PokemonDetailCubit>().fetchPokemonDetail(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.purple));
          } else if (state.errorMessage.isNotEmpty) {
            return Center(child: Text(state.errorMessage));
          } else if (state.pokemonDetail != null) {
            final p = state.pokemonDetail!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Top Section with Image and Background
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Hero(
                          tag: p.id,
                          child: Image.network(
                            p.imageUrl,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Name and Chips
                  Text(
                    p.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: p.types.map((type) => Chip(
                      label: Text(
                        type.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: _getTypeColor(type),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Stats Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Base Stats',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ...p.stats.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  _formatStatName(entry.key),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: entry.value / 200, // Normalize roughly
                                    backgroundColor: Colors.grey[200],
                                    color: _getStatColor(entry.key),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        
                        const SizedBox(height: 24),
                        
                        // Height & Weight
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             _buildInfoColumn('Height', '${p.height / 10} m'),
                             _buildInfoColumn('Weight', '${p.weight / 10} kg'),
                           ],
                         ),
                         const SizedBox(height: 40),

                         // Evolutions Section
                         if (p.evolutions.isNotEmpty) ...[
                           const Text(
                             'Evolution Chain',
                             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                           ),
                           const SizedBox(height: 16),
                           SizedBox(
                             height: 140,
                             child: ListView.builder(
                               scrollDirection: Axis.horizontal,
                               itemCount: p.evolutions.length,
                               itemBuilder: (context, index) {
                                 final evo = p.evolutions[index];
                                 final isCurrent = evo['id'] == p.id;
                                 return GestureDetector(
                                   onTap: () {
                                     if (isCurrent) return;
                                     // Navigate to selected evolution
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                         builder: (_) => BlocProvider(
                                            create: (_) => di.getIt<PokemonDetailCubit>(),
                                            child: PokemonDetailPage(pokemonId: evo['id']),
                                         ),
                                       ),
                                     );
                                   },
                                   child: Container(
                                     width: 100,
                                     margin: const EdgeInsets.only(right: 12),
                                     decoration: BoxDecoration(
                                       color: isCurrent ? Colors.purple.withOpacity(0.1) : Colors.white,
                                       border: Border.all(color: Colors.grey.shade200),
                                       borderRadius: BorderRadius.circular(15),
                                     ),
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Image.network(evo['imageUrl'], height: 70),
                                         const SizedBox(height: 8),
                                         Text(
                                            (evo['name'] as String).toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12, 
                                              fontWeight: FontWeight.bold,
                                              color: isCurrent ? Colors.purple : Colors.black87
                                            ),
                                            textAlign: TextAlign.center,
                                         ),
                                       ],
                                     ),
                                   ),
                                 );
                               },
                             ),
                           ),
                           const SizedBox(height: 40),
                         ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  String _formatStatName(String name) {
    switch (name) {
      case 'hp': return 'HP';
      case 'attack': return 'Attack';
      case 'defense': return 'Defense';
      case 'special-attack': return 'Sp. Atk';
      case 'special-defense': return 'Sp. Def';
      case 'speed': return 'Speed';
      default: return name.toUpperCase();
    }
  }

  Color _getStatColor(String stat) {
    switch (stat) {
      case 'hp': return Colors.green;
      case 'attack': return Colors.red;
      case 'defense': return Colors.blue;
      case 'speed': return Colors.orange;
      default: return Colors.purple;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'fire': return Colors.orange;
      case 'water': return Colors.blue;
      case 'grass': return Colors.green;
      case 'electric': return Colors.amber;
      case 'poison': return Colors.purple;
      case 'bug': return Colors.lightGreen;
      case 'flying': return Colors.indigo;
      default: return Colors.grey;
    }
  }
}
