import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/favorites_provider.dart';
import '../provider/joke_provider.dart';

class JokePage extends ConsumerWidget {
  final cardsSwiperController = CardSwiperController();

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _swipeJoke(
      int index, CardSwiperDirection direction, WidgetRef ref) async {
    var currentJoke = ref.watch(jokesProvider).jokes[index];
    if (direction == CardSwiperDirection.right) {
      ref.read(favoritesProvider.notifier).addFavorite(currentJoke);
    }
    ref.read(jokesProvider.notifier).updateJokeList(index);
  }

  void _showSearch() {
    print("Search");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(jokesProvider).jokes;
    final isLoading = ref.watch(jokesProvider).isLoading;

    return isLoading
        ? Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: IconButton(
                onPressed: _signOut,
                icon: Icon(Icons.logout_rounded),
              ),
              trailing: IconButton(
                onPressed: _showSearch,
                icon: Icon(Icons.search_rounded),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: CardSwiper(
                      controller: cardsSwiperController,
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                        onPressed: cardsSwiperController.swipeLeft,
                        child: const Icon(Icons.close)),
                    FloatingActionButton(
                        onPressed: cardsSwiperController.swipeRight,
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
