import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appinio_swiper/appinio_swiper.dart';

import 'package:tinder_with_chuck/model/joke_model.dart';
import 'joke_card_model.dart';
import 'joke_card.dart';
import 'swipe_buttons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Joke App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final _arrLength = 3;

  List<JokeCard> cards = [];

  JokeCard currentJoke = JokeCard(
      jokeModel: JokeCardModel(text: "", color: gradientRed));

  List<JokeCard> favoriteJokes = [];

  JokeCard _getJokeCard(String text){
    LinearGradient color;

    Random rnd;
    int max = numberOfColorGradients;
    rnd = Random();
    var randInt = rnd.nextInt(max);

    switch (randInt){
      case 0:
        color = gradientRed;
        break;
      case 1:
        color = gradientPurple;
        break;
      case 2:
        color = gradientBlue;
        break;
      case 3:
        color = gradientPink;
        break;
      case 4:
        color = kNewFeedCardColorsIdentityGradient;
        break;
      default:
        throw UnimplementedError('No color gradient for $randInt');
    }

    return JokeCard(jokeModel: JokeCardModel(text: text, color: color));
  }

  void updateJokeList() async {
    if (cards.isEmpty) {
      for (int i = 0; i < _arrLength; i++) {
        var result = await http.get(
            Uri.parse("https://api.chucknorris.io/jokes/random"));

        Map<String, dynamic> data = jsonDecode(result.body);

        var currentJokeModel = JokeModel
            .fromJson(data)
            .value;

        cards.add(_getJokeCard(currentJokeModel));
      }
      currentJoke = cards[cards.length - 1];
      notifyListeners();

    } else{
      while (cards.length < _arrLength){
        var result = await http.get(
            Uri.parse("https://api.chucknorris.io/jokes/random"));

        Map<String, dynamic> data = jsonDecode(result.body);

        var currentJokeModel = JokeModel
            .fromJson(data)
            .value;

        cards.insert(0, _getJokeCard(currentJokeModel));
      }
      currentJoke = cards[cards.length - 1];
    }
  }

  void swipeJoke(int index, AppinioSwiperDirection direction){
    print("the card index $index was swiped to the: ${direction.name}");
    print(currentJoke.jokeModel.text);
    updateJokeList();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();


    Widget page;
    switch (pageIndex) {
      case 0:
        page = SettingsPage();
        break;
      case 1:
        page = JokePage();
        appState.updateJokeList();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
            return Column(
              children: [
                Expanded(child: page),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
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
                      setState(() {
                        pageIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return Center(
      child: Text('No setting yet.'),
    );
  }
}


class JokePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // appState.updateJokeList();

    List<JokeCard> cards = appState.cards;
    AppinioSwiperController controller = AppinioSwiperController();

    return CupertinoPageScaffold(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
            child: AppinioSwiper(
              allowUnswipe: false,
              controller: controller,
              cards: cards,
              onSwipe: appState.swipeJoke,
              onEnd: appState.updateJokeList,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 50,
                bottom: 40,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              swipeLeftButton(controller),
              const SizedBox(
                width: 20,
              ),
              swipeRightButton(controller),
            ],
          )
        ],
      ),
    );
  }

}


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favoriteJokes.isEmpty) {
      return Center(
        child: Text('No favorites jokes yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text('You have ${appState.favoriteJokes.length} favorites')],
    );
  }
}
