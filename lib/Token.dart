import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = StateProvider<Token>((ref) {
  final token = Token(
    accessToken: null,
    id: null,
    gender: null
  );

  return token;
});

class Token {
  final String? accessToken;
  final int? id;
  final String? gender;

  Token({required this.accessToken, required this.id, required this.gender});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(accessToken: json["accessToken"], id: json["id"], gender: json["gender"]);
  }
}
