import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../widgets/joke_card.dart';

part 'favorites_provider.freezed.dart';

// Creating state where the freezed annotation will suggest that boilerplate code needs to be generated
@freezed
abstract class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<String> jokes,
    @Default(true) isLoading,
  }) = _FavoritesState;

  const FavoritesState._();
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>(
        (ref) => FavoritesNotifier());

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier() : super(FavoritesState()) {
    loadFavoritesList();
  }

  void loadFavoritesList() {}

  void addFavorite(JokeCard card) {
    if (card.jokeModel.text != null) {
      state = state.copyWith(isLoading: true);

      List<String> jokes = [for (final joke in state.jokes) joke];
      jokes.add(card.jokeModel.text!);
      state = state.copyWith(isLoading: false, jokes: jokes);
    }
  }

  void removeFavorite(String joke) {
    print("remove $joke");
  }
}
