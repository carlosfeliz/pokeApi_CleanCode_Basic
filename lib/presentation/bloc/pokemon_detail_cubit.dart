import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../../domain/usecases/get_pokemons.dart'; // Contains GetPokemonDetail

class PokemonDetailState {
  final PokemonDetail? pokemonDetail;
  final bool isLoading;
  final String errorMessage;

  PokemonDetailState({
    this.pokemonDetail,
    required this.isLoading,
    required this.errorMessage,
  });

  factory PokemonDetailState.initial() {
    return PokemonDetailState(
      isLoading: true, // Start loading immediately usually
      errorMessage: '',
    );
  }

  PokemonDetailState copyWith({
    PokemonDetail? pokemonDetail,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PokemonDetailState(
      pokemonDetail: pokemonDetail ?? this.pokemonDetail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final GetPokemonDetail getPokemonDetail;

  PokemonDetailCubit(this.getPokemonDetail) : super(PokemonDetailState.initial());

  Future<void> fetchPokemonDetail(int id) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      final detail = await getPokemonDetail.execute(id);
      emit(state.copyWith(pokemonDetail: detail, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }
}
