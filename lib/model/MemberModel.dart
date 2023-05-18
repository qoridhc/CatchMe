class MemberModel {
  final String memberId;
  final String nickname;
  final String imageUrls;
  final String birthYear;
  final String introduction;
  final String gender;
  final String mbti;
  final String averageScore;

  MemberModel({
    required this.memberId,
    required this.nickname,
    required this.imageUrls,
    required this.birthYear,
    required this.introduction,
    required this.gender,
    required this.mbti,
    required this.averageScore,
  });

  factory MemberModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return MemberModel(
      memberId: json['memberId'],
      nickname: json['nickname'],
      imageUrls: json['imageUrls'],
      birthYear: json['birthYear'],
      introduction: json['introduction'],
      gender: json['gender'],
      mbti: json['mbti'],
      averageScore: json['averageScore'],
    );
  }
}
