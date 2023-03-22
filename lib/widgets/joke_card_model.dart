import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'joke_card.dart';

class JokeCardModel {
  String? text;
  LinearGradient? color;

  JokeCardModel({
    this.text,
    this.color,
  });
}

const numberOfColorGradients = 5;

const LinearGradient gradientRed = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFF3868),
    Color(0xFFFFB49A),
  ],
);

const LinearGradient gradientPurple = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF736EFE),
    Color(0xFF62E4EC),
  ],
);

const LinearGradient gradientBlue = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF0BA4E0),
    Color(0xFFA9E4BD),
  ],
);

const LinearGradient gradientPink = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFF6864),
    Color(0xFFFFB92F),
  ],
);

const LinearGradient kNewFeedCardColorsIdentityGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF7960F1),
    Color(0xFFE1A5C9),
  ],
);

JokeCard getJokeCard(String text) {
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
