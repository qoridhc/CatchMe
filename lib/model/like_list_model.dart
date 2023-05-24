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
        likeList: json['likeList']
            .map<LikeModel>(
            (x) => LikeModel.fromJson(json: x),
        )
    );
  }
}

class LikeModel{
  final int id;
  final String nickname;
  final List<String> imgUrls;
  final String gender;
  final String time;

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
        id: json['id'],
        nickname: json['nickname'],
        imgUrls: json['imgUrls'],
        gender: json['gender'],
        time: json['time'].toString(),
    );
  }
}