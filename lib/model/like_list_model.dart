class LikeListModel{
  final count;
  final List<LikeModel> likeList;

  LikeListModel({
    required this.count,
    required this.likeList,
  });

  factory LikeListModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return LikeListModel(
        count: json['count'],
        likeList: json["data"]
            .map<LikeModel>(
            (x) => LikeModel.fromJson(json: x),
        ).toList(),
    );
  }
}

class LikeModel{
  final int id;
  final String nickname;
  final List<String> imgUrls;
  final String gender;
  final DateTime time;

  LikeModel({
    required this.id,
    required this.nickname,
    required this.imgUrls,
    required this.gender,
    required this.time,
  });

  factory LikeModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return LikeModel(
        id: json['memberId'],
        nickname: json['nickname'],
        imgUrls: json['imageUrls'],
        gender: json['gender'],
        time: json['time'],
    );
  }
}