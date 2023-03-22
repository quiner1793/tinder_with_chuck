import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tinder_with_chuck/provider/favorites_provider.dart';
import 'package:tinder_with_chuck/provider/joke_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/joke_card_model.dart';
import 'widgets/joke_card.dart';

final homePageProvider = StateProvider((ref) => 0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // bool isAuth = (FirebaseAuth.instance.currentUser?.uid != null);

    return MaterialApp(
        title: 'Joke App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(homePageProvider);

    Widget page;
    switch (pageIndex) {
      case 0:
        page = InfoPage();
        break;
      case 1:
        page = JokePage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(child: page),
            SafeArea(
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.info),
                    label: 'Info',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                ],
                currentIndex: pageIndex,
                onTap: (value) {
                  ref.read(homePageProvider.notifier).state = value;
                },
              ),
            )
          ],
        );
      }),
    );
  }
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return ListView(
      children: <Widget>[
        Container(
          height: 400,
          decoration: BoxDecoration(gradient: gradientRed),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Anatoliy Shvarts',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Chuck Norris joke app',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Telegram',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '@quiner123',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'a.shvarts@innopolis.university',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'GitHub',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'https://github.com/quiner1793/tinder_with_chuck',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

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

class FavoritesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final List<String> jokeList = ref.watch(favoritesProvider).jokes;
    final bool isLoading = ref.watch(favoritesProvider).isLoading;

    // if (jokeList.isEmpty) {
    //   return Center(
    //     child: Text('No favorites jokes yet.'),
    //   );
    // }

    return isLoading
        ? Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text('You have '
                    '${jokeList.length} favorites:'),
              ),
              Expanded(
                  child: ListView(
                children: [
                  for (var joke in jokeList)
                    ListTile(
                      leading: IconButton(
                        icon:
                            Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                        color: theme.colorScheme.primary,
                        onPressed: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .removeFavorite(joke);
                        },
                      ),
                      title: Text(joke),
                    ),
                ],
              ))
            ],
          );
  }
}
