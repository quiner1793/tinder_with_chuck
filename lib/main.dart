import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tinder_with_chuck/model/joke_model.dart';
import 'joke_card_model.dart';
import 'joke_card.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

  // late final Future<Database> database;

  // MyAppState(){
  //   _init();
  // }
  //
  // Future _init() async {
  //   database = openDatabase(
  //     join(await getDatabasesPath(), 'joke_database.db'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //         'CREATE TABLE jokes(id INTEGER PRIMARY KEY, joke TEXT)',
  //       );
  //     },
  //     version: 1,
  //   );
  //
  //   print(await database.query('dogs');)
  // }

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
  var _pageIndex = 0;
  bool _loginPage = true;
  bool _signUpPage = false;

  _showAlertDialog(BuildContext context, String message) {

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _signInUser(String email, String password, BuildContext context) async{
    final bool emailValid =
    RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
        .hasMatch(email);
    if (!emailValid && _loginPage){
      _showAlertDialog(context, 'Invalid email.');
    } else{
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        setState(() {
          _loginPage = false;
          _signUpPage = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          if (_loginPage){
            _showAlertDialog(context, 'No user found for that email.');
          }
        } else if (e.code == 'wrong-password') {
          if (_loginPage){
            _showAlertDialog(context, 'Wrong password provided for that user.');
          }
        }
      }
    }
  }

  void _registerUser(String email, String password, BuildContext context) async{
    final bool emailValid =
    RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
        .hasMatch(email);
    if (!emailValid && _signUpPage){
      _showAlertDialog(context, 'Invalid email.');
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (_signUpPage) {
            _showAlertDialog(context, 'The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
          if (_loginPage) {
            _showAlertDialog(
                context, 'The account already exists for that email.');
          }
        }
      } catch (e) {
        if (_signUpPage) {
          _showAlertDialog(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var colorScheme = Theme.of(context).colorScheme;

    if (_loginPage){
      final TextEditingController emailController = TextEditingController();
      final TextEditingController passwordController = TextEditingController();

      return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(50),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Tinder with Chuck Norris',
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Welcome back',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Log in'),
                        onPressed: () {
                          _signInUser(emailController.text, passwordController.text, context);
                        },
                      )
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Does not have an account?'),
                      TextButton(
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          setState(() {
                            _loginPage = false;
                            _signUpPage = true;
                          });
                        },
                      )
                    ],
                  ),
                ],
              )
          )
      );
    }

    if (_signUpPage){
      final TextEditingController emailController = TextEditingController();
      final TextEditingController passwordController = TextEditingController();

      return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(50),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Tinder with Chuck Norris',
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () {
                          _registerUser(emailController.text, passwordController.text, context);
                          _signInUser(emailController.text, passwordController.text, context);
                        },
                      )
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Already have an account?'),
                      TextButton(
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          setState(() {
                            _loginPage = true;
                            _signUpPage = false;
                          });
                        },
                      )
                    ],
                  ),
                ],
              )
          )
      );
    }

    appState.initJokeList();

    Widget page;
    switch (_pageIndex) {
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
        throw UnimplementedError('no widget for $_pageIndex');
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
                currentIndex: _pageIndex,
                onTap: (value) {
                  setState(() {
                    _pageIndex = value;
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
