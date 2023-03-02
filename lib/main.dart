import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tinder_with_chuck/model/joke_model.dart';
import 'dart:convert';


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
  var currentJoke = "";
  var favoriteJokes = <String>[];

  void updateJoke() async {
    var result = await http.get(Uri.parse("https://api.chucknorris.io/jokes/random"));
    Map<String, dynamic> data = await jsonDecode(result.body);

    currentJoke = JokeModel.fromJson(data).value;
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
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (pageIndex) {
      case 0:
        page = SettingsPage();
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
    var joke = appState.currentJoke;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(joke)],
      )
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
