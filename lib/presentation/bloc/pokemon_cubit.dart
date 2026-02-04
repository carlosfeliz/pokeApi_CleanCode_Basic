import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_pokemons.dart';

class PokemonState {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final String errorMessage;

  PokemonState({
    required this.pokemons,
    required this.isLoading,
    required this.errorMessage,
  });

  factory PokemonState.initial() {
    return PokemonState(
      pokemons: [],
      isLoading: false,
      errorMessage: '',
    );
  }

  PokemonState copyWith({
    List<Pokemon>? pokemons,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PokemonState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
class PokemonCubit extends Cubit<PokemonState> {
  final GetPokemons getPokemons;
  int _page = 0;

  PokemonCubit(this.getPokemons) : super(PokemonState.initial());

  Future<void> fetchPokemons({bool reset = false}) async {
    if (reset) {
      _page = 0;
      emit(state.copyWith(isLoading: true, pokemons: [])); // Reset list on full refresh
    } else {
      // If we are already loading or at end? (Infinite scroll logic usually needs 'hasReachedMax')
      // For now let's just use isLoading to prevent double fetch
      if (state.isLoading) return; 
      // We could add a separate 'isLoadingMore' to state to not show full screen loader for next pages
      // For simplicity in this step, re-using isLoading but we might want to distinguish UI.
    }
    
    // Simplification: unique loading state for first load vs others would be better for UX
    // But let's stick to base requirements first.
    // Actually, if we use 'isLoading' for everything, the list will disappear on "Load More" if we aren't careful.
    // Let's treat 'isLoading' as 'First Loading' mostly.
    
    if (_page == 0) emit(state.copyWith(isLoading: true)); 
    
    try {
      final newPokemons = await getPokemons.execute(page: _page);
      
      final totalPokemons = reset ? newPokemons : [...state.pokemons, ...newPokemons];
      
      emit(state.copyWith(
        pokemons: totalPokemons, 
        isLoading: false
      ));
      
      _page++;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}

