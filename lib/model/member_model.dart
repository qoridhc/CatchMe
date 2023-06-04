class MemberListModel {
  final count;
  final List<MemberModel> memberList;

  MemberListModel({
    required this.count,
    required this.memberList,
  });

  factory MemberListModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return MemberListModel(
      count: json['count'],
      memberList: json['data']
          .map<MemberModel>(
            (x) => MemberModel.fromJson(json: x),
          )
          .toList(),
    );
  }
}
class MemberModel {
  final String memberId;
  final String nickname;
  final List<dynamic> imageUrls;
  final String birthYear;
  final String? introduction;
  final String gender;
  final String mbti;
  final double averageScore;
  final String email;

  MemberModel({
    required this.memberId,
    required this.nickname,
    required this.imageUrls,
    required this.birthYear,
    required this.introduction,
    required this.gender,
    required this.mbti,
    required this.averageScore,
    required this.email,
  });

  factory MemberModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return MemberModel(
      memberId: json['memberId'].toString(),
      nickname: json['nickname'],
      imageUrls: json['imageUrls'],
      birthYear: json['birthYear'],
      introduction: json['introduction'],
      gender: json['gender'],
      mbti: json['mbti'],
      averageScore: json['averageScore'],
      email: json['email'],
    );
  }

  MemberModel copyWith({
    required Map<String, dynamic> json,
  }) {
    return MemberModel(
      memberId: json['memberId'] ?? this.memberId,
      nickname: json['nickname'] ?? this.nickname,
      imageUrls: json['imageUrls'] ?? this.imageUrls,
      birthYear: json['birthYear'] ?? this.birthYear,
      introduction: json['introduction'] ?? this.introduction,
      gender: json['gender'] ?? this.gender,
      mbti: json['mbti'] ?? this.mbti,
      averageScore: json['averageScore'] ?? this.averageScore,
      email : json['email'] ?? this.email,
    );
  }
}