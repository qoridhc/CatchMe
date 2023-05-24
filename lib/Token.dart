import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = StateProvider<Token>((ref) {
  final token = Token(
    accessToken: null,
    id: null,
  );

  return token;
});

class Token {
  final String? accessToken;
  final int? id;

  Token({required this.accessToken, required this.id});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(accessToken: json["accessToken"], id: json["id"]);
  }
}
