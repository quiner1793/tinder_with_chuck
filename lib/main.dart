import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import 'package:tinder_with_chuck/model/joke_model.dart';
import 'joke_card_model.dart';
import 'joke_card.dart';

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
  final _arrLength = 10;

  List<JokeCard> cards = [];

  JokeCard currentJoke =
      JokeCard(jokeModel: JokeCardModel(text: "", color: gradientRed));

  List<JokeCard> favoriteJokes = [];

  JokeCard _getJokeCard(String text) {
    LinearGradient color;

    Random rnd;
    int max = numberOfColorGradients;
    rnd = Random();
    var randInt = rnd.nextInt(max);

    switch (randInt) {
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

  void initJokeList() async {
    while (cards.length < _arrLength) {
      var result =
          await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));

      Map<String, dynamic> data = jsonDecode(result.body);

      var currentJokeModel = JokeModel.fromJson(data).value;

      cards.add(_getJokeCard(currentJokeModel));
    }
  }

  void updateJokeList(int index) async {
    if (index >= 0 && index < cards.length) {
      var result =
          await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));

      Map<String, dynamic> data = jsonDecode(result.body);

      var currentJokeModel = JokeModel.fromJson(data).value;

      cards[index] = _getJokeCard(currentJokeModel);
    }
  }

  void addFavorite(JokeCard card) {
    favoriteJokes.add(card);
  }

  void removeFavorite(JokeCard card) {
    favoriteJokes.remove(card);
    notifyListeners();
  }

  void swipeJoke(int index, CardSwiperDirection direction) {
    if (direction.name == "right") {
      addFavorite(cards[index]);
    }

    updateJokeList(index);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.initJokeList();

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
                  setState(() {
                    pageIndex = value;
                  });
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

class JokePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    final List<JokeCard> cards = appState.cards;
    final CardSwiperController controller = CardSwiperController();

    return CupertinoPageScaffold(
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
              onSwipe: appState.swipeJoke,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                  onPressed: controller.swipeLeft,
                  child: const Icon(Icons.close)),
              const SizedBox(
                width: 20,
              ),
              FloatingActionButton(
                  onPressed: controller.swipeRight,
                  child: const Icon(Icons.favorite)),
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
      children: [
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favoriteJokes.length} favorites:'),
        ),
        Expanded(
            child: ListView(
          children: [
            for (var jokeCard in appState.favoriteJokes)
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                  color: theme.colorScheme.primary,
                  onPressed: () {
                    appState.removeFavorite(jokeCard);
                  },
                ),
                title: Text(jokeCard.jokeModel.text.toString()),
              ),
          ],
        ))
      ],
    );
  }
}
