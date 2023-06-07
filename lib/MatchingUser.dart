
class MatchingUser{
  final int? id;
  final String? gender;

  MatchingUser({required this.id, required this.gender});

  Map<String,dynamic> toJson() =>{
    'id':id,
    'gender':gender
  };


  factory MatchingUser.fromJson(Map<String, dynamic> json){
    return MatchingUser(id: json["id"], gender: json["gender"]);
  }
}