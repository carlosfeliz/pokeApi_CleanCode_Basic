import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pokemon_cubit.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/pokemon_skeleton_card.dart';
import 'pokemon_detail_page.dart';
import '../../injection.dart' as di;
import '../bloc/pokemon_detail_cubit.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    context.read<PokemonCubit>().fetchPokemons(reset: true);
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonCubit>().fetchPokemons();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Trigger when 90% scrolled
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: BlocBuilder<PokemonCubit, PokemonState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple, Colors.deepPurple], // Modern gradient
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(bottom: 20),
                    title: const Text(
                      'Pokédex',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1.5,
                      ),
                    ),
                    background: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Icon(
                            Icons.catching_pokemon, 
                            size: 150, 
                            color: Colors.white.withOpacity(0.1)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              if (state.isLoading && state.pokemons.isEmpty)
                // Skeleton Loading for initial load
                SliverPadding(
                   padding: const EdgeInsets.all(16.0),
                   sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const PokemonSkeletonCard(),
                      childCount: 6,
                    ),
                   ),
                )
              else if (state.errorMessage.isNotEmpty && state.pokemons.isEmpty)
                SliverFillRemaining(
                  child: Center(child: Text(state.errorMessage)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pokemon = state.pokemons[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => di.getIt<PokemonDetailCubit>(),
                                  child: PokemonDetailPage(pokemonId: pokemon.id),
                                ),
                              ),
                            );
                          },
                          child: PokemonCard(pokemon: pokemon),
                        );
                      },
                      childCount: state.pokemons.length,
                    ),
                  ),
                ),
                
               // Bottom loader if needed (or we can just let it load silently)
               // For now, no specific footer loader to match "simple" request but skeletons are there.
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<PokemonCubit>().fetchPokemons(reset: true),
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text('Refresh', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
