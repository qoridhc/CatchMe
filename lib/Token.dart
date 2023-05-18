class Token{
  final String accessToken;
  final int id;

  Token({required this.accessToken,
    required this.id});

  factory Token.fromJson(Map<String, dynamic> json){
    return Token(accessToken: json["accessToken"], id: json["id"]);
  }
}