import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
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

  void _signInUser(String email, String password, BuildContext context) async {
    final bool emailValid = RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
        .hasMatch(email);
    if (!emailValid && _loginPage) {
      _showAlertDialog(context, 'Invalid email.');
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        setState(() {
          _loginPage = false;
          _signUpPage = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          if (_loginPage) {
            _showAlertDialog(context, 'No user found for that email.');
          }
        } else if (e.code == 'wrong-password') {
          if (_loginPage) {
            _showAlertDialog(context, 'Wrong password provided for that user.');
          }
        }
      }
    }
  }

  void _registerUser(
      String email, String password, BuildContext context) async {
    final bool emailValid = RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
        .hasMatch(email);
    if (!emailValid && _signUpPage) {
      _showAlertDialog(context, 'Invalid email.');
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    var colorScheme = Theme.of(context).colorScheme;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    if (_loginPage) {
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
                          _signInUser(emailController.text,
                              passwordController.text, context);
                        },
                      )),
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
              )));
    }

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
                        _registerUser(emailController.text,
                            passwordController.text, context);
                        _signInUser(emailController.text,
                            passwordController.text, context);
                      },
                    )),
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
            )));
  }
}
