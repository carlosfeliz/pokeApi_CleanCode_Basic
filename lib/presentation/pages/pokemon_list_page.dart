import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pokemon_cubit.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pokémons')),
      body: BlocBuilder<PokemonCubit, PokemonState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage.isNotEmpty) {
            return Center(child: Text(state.errorMessage));
          } else if (state.pokemons.isEmpty) {
            return const Center(child: Text('No hay Pokémones disponibles.'));
          } else {
            return ListView.builder(
              itemCount: state.pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = state.pokemons[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(pokemon.imageUrl),
                    title: Text(pokemon.name),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PokemonCubit>().fetchPokemons(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
