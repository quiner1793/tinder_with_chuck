import 'dart:convert';

import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tinder_with_chuck/widgets/joke_card_model.dart';

import '../model/joke_model.dart';
import '../widgets/joke_card.dart';
import 'package:http/http.dart' as http;

part 'joke_provider.freezed.dart';

CardSwiperController cardSwiperController = CardSwiperController();

// Creating state where the freezed annotation will suggest that boilerplate code needs to be generated
@freezed
abstract class JokeState with _$JokeState {
  const factory JokeState({
    // required CardSwiperController cardSwiperController,
    @Default([]) List<JokeCard> jokes,
    @Default([]) List<String> jokeCategories,
    @Default("all") String currentCategory,
    @Default(true) isLoading,
  }) = _JokeState;

  const JokeState._();
}

final jokesProvider =
    StateNotifierProvider<JokeNotifier, JokeState>((ref) => JokeNotifier());

class JokeNotifier extends StateNotifier<JokeState> {
  final _jokeListLength = 10;

  JokeNotifier() : super(JokeState()) {
    loadCategoriesList();
    loadJokeList("all");
  }

  void loadNewController() async {
    cardSwiperController = CardSwiperController();
  }

  void loadJokeList(String category) async {
    state = state.copyWith(isLoading: true);
    cardSwiperController = CardSwiperController();

    String request = "https://api.chucknorris.io/jokes/random";

    if (category != "all") {
      request = "https://api.chucknorris.io/jokes/random?category=$category";
    }

    List<JokeCard> jokes = [];
    for (int i = 0; i < _jokeListLength; i++) {
      var result = await http.get(Uri.parse(request));

      Map<String, dynamic> data = jsonDecode(result.body);

      var currentJokeModel = JokeModel.fromJson(data).value;

      jokes.add(getJokeCard(currentJokeModel));
    }
    state = state.copyWith(jokes: jokes, isLoading: false);
  }

  void loadCategoriesList() async {
    state = state.copyWith(isLoading: true);

    List<String> categories = [
      "all",
      "animal",
      "career",
      "celebrity",
      "dev",
      "explicit",
      "fashion",
      "food",
      "history",
      "money",
      "movie",
      "music",
      "political",
      "religion",
      "science",
      "sport",
      "travel"
    ];

    state = state.copyWith(jokeCategories: categories);
  }

  void changeCurrentCategory(String category) async {
    state = state.copyWith(currentCategory: category);
    loadJokeList(category);
  }

  void updateJokeList(int index) async {
    if (index >= 0 && index < _jokeListLength) {
      List<JokeCard> jokes = [for (final joke in state.jokes) joke];

      var result = await http.get(Uri.parse(
          "https://api.chucknorris.io/jokes/random")); // TODO try catch for API calls

      Map<String, dynamic> data = jsonDecode(result.body);

      var currentJokeModel = JokeModel.fromJson(data).value;

      jokes[index] = getJokeCard(currentJokeModel);
      state = state.copyWith(isLoading: false, jokes: jokes);
    }
  }
}
