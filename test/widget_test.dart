// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arq_limpia_cfr/domain/entities/pokemon.dart';
import 'package:arq_limpia_cfr/domain/entities/pokemon_detail.dart';
import 'package:arq_limpia_cfr/domain/usecases/get_pokemons.dart';
import 'package:arq_limpia_cfr/presentation/bloc/pokemon_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:arq_limpia_cfr/main.dart';
import 'package:arq_limpia_cfr/presentation/pages/pokemon_list_page.dart';
import 'package:arq_limpia_cfr/injection.dart' as di;

// Mocks
class MockPokemonRepository implements PokemonRepository {
  @override
  Future<List<Pokemon>> getPokemonsFromApi({int offset = 0, int limit = 10}) async => [];
  @override
  Future<List<Pokemon>> getPokemonsFromLocal() async => [];
  @override
  Future<void> savePokemons(List<Pokemon> pokemons) async {}
  
  @override
  Future<PokemonDetail> getPokemonDetail(int id) async {
    throw UnimplementedError();
  }
}

class MockGetPokemons extends GetPokemons {
  MockGetPokemons() : super(MockPokemonRepository());
  
  @override
  Future<List<Pokemon>> execute({int page = 0}) async => [];
}

class MockPokemonCubit extends PokemonCubit {
  MockPokemonCubit() : super(MockGetPokemons());
  
  // Override to prevent real execution and just allow calling it
  @override
  Future<void> fetchPokemons({bool reset = false}) async {
     // No-op for test or emit dummy state
  }
}

void main() {
  setUp(() {
    GetIt.instance.registerFactory<PokemonCubit>(() => MockPokemonCubit());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('Smoke test: App launches and shows PokemonListPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the PokemonListPage is displayed via finding a widget type.
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Check for the new UI structure (CustomScrollView is used in the new page)
    expect(find.byType(CustomScrollView), findsOneWidget);
  });
}
