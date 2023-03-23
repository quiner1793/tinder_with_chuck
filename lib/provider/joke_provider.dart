import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tinder_with_chuck/widgets/joke_card_model.dart';

import '../model/joke_model.dart';
import '../widgets/joke_card.dart';
import 'package:http/http.dart' as http;

part 'joke_provider.freezed.dart';

// Creating state where the freezed annotation will suggest that boilerplate code needs to be generated
@freezed
abstract class JokeState with _$JokeState {
  const factory JokeState({
    @Default([]) List<JokeCard> jokes,
    @Default(true) isLoading,
  }) = _JokeState;

  const JokeState._();
}

final jokesProvider =
    StateNotifierProvider<JokeNotifier, JokeState>((ref) => JokeNotifier());

class JokeNotifier extends StateNotifier<JokeState> {
  final _jokeListLength = 10;

  JokeNotifier() : super(JokeState()) {
    loadJokeList();
  }

  void loadJokeList() async {
    state = state.copyWith(isLoading: true);

    List<JokeCard> jokes = [];
    for (int i = 0; i < _jokeListLength; i++) {
      var result =
          await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));

      Map<String, dynamic> data = jsonDecode(result.body);

      var currentJokeModel = JokeModel.fromJson(data).value;

      jokes.add(getJokeCard(currentJokeModel));
    }
    state = state.copyWith(jokes: jokes, isLoading: false);
  }

  void updateJokeList(int index) async {
    if (index >= 0 && index < _jokeListLength) {

      List<JokeCard> jokes = [for (final joke in state.jokes) joke];

      var result =
          await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));

      Map<String, dynamic> data = jsonDecode(result.body);

      var currentJokeModel = JokeModel.fromJson(data).value;

      jokes[index] = getJokeCard(currentJokeModel);
      state = state.copyWith(isLoading: false, jokes: jokes);
    }
  }
}
