import 'package:json_annotation/json_annotation.dart';

part 'joke_model.g.dart';

@JsonSerializable()
class JokeModel {
  String value;

  JokeModel(this.value);

  @override
  String toString() => value;

  factory JokeModel.fromJson(Map<String, dynamic> json) =>
      _$JokeModelFromJson(json);

  Map<String, dynamic> toJson() => _$JokeModelToJson(this);
}
