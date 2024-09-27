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

  PokemonCubit(this.getPokemons) : super(PokemonState.initial());

  Future<void> fetchPokemons() async {
    emit(state.copyWith(isLoading: true));
    try {
      final pokemons = await getPokemons.execute();
      print(pokemons); // Verifica que los pokémones están siendo cargados
      emit(state.copyWith(pokemons: pokemons, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}

