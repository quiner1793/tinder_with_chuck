import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_database/firebase_database.dart';

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
  DatabaseReference? _databaseRef;
  String? _uid;

  FavoritesNotifier() : super(FavoritesState()) {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _databaseRef = FirebaseDatabase.instance.ref("users");
    print(_uid);

    loadFavoritesList();
  }

  void reInitAuthState() {
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _databaseRef = FirebaseDatabase.instance.ref("users");

    loadFavoritesList();
  }

  void _updateFavoritesDB(List<String> jokeList) {
    try {
      _databaseRef?.child(_uid!).update({
        'favorites': jokeList,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void loadFavoritesList() async {
    if (_databaseRef != null && _uid != null){
      state = state.copyWith(isLoading: true);

      try {
        final snapshot = await _databaseRef!.child("$_uid/favorites").get();

        if (snapshot.exists) {
          List<dynamic> favorites = json.decode(jsonEncode(snapshot.value));
          List<String> favoritesList =
          favorites.map((e) => e.toString()).toList();
          state = state.copyWith(jokes: favoritesList);
        } else {
          _updateFavoritesDB([]);
          state = state.copyWith(jokes: []);
        }
      } on FirebaseException catch (e) {
        print(e);
      }
      state = state.copyWith(isLoading: false);
    } else {
      throw Exception("Firebase auth state not initialized");
    }
  }

  void addFavorite(JokeCard card) {
    if (card.jokeModel.text != null) {
      state = state.copyWith(isLoading: true);

      List<String> jokes = [card.jokeModel.text!];
      for (final joke in state.jokes) {
        jokes.add(joke);
      }
      _updateFavoritesDB(jokes);

      state = state.copyWith(isLoading: false, jokes: jokes);
    }
  }

  void removeFavorite(String jokeToRemove) {
    state = state.copyWith(isLoading: true);
    List<String> jokes = [];
    for (final joke in state.jokes) {
      if (joke != jokeToRemove) {
        jokes.add(joke);
      }
    }
    _updateFavoritesDB(jokes);

    state = state.copyWith(isLoading: false, jokes: jokes);
  }
}
