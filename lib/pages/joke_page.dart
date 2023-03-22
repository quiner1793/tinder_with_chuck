import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/favorites_provider.dart';
import '../provider/joke_provider.dart';
import '../widgets/joke_card.dart';

class JokePage extends ConsumerWidget {
  void _swipeJoke(
      int index, CardSwiperDirection direction, WidgetRef ref) async {
    var currentJoke = ref.watch(jokesProvider).jokes[index];
    if (direction.name == "right") {
      ref.read(favoritesProvider.notifier).addFavorite(currentJoke);
    }
    ref.read(jokesProvider.notifier).updateJokeList(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<JokeCard> cards = ref.watch(jokesProvider).jokes;
    final isLoading = ref.watch(jokesProvider).isLoading;
    final CardSwiperController controller = CardSwiperController();

    return isLoading
        ? Center(
        child: SizedBox(
            width: 30, height: 30, child: CircularProgressIndicator()))
        : CupertinoPageScaffold(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: CardSwiper(
                  controller: controller,
                  cards: cards,
                  onSwipe: (int index, CardSwiperDirection direction) {
                    _swipeJoke(index, direction, ref);
                  },
                  isVerticalSwipingEnabled: false,
                  isLoop: true,
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 50,
                    bottom: 40,
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                  onPressed: controller.swipeLeft,
                  child: const Icon(Icons.close)),
              FloatingActionButton(
                  onPressed: controller.swipeRight,
                  child: const Icon(Icons.favorite)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}