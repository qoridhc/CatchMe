class SingleRoomListModel{
  final count;
  final List<SingleRoomModel> singleRoomList;

  SingleRoomListModel({
    required this.count,
    required this.singleRoomList,
  });

  factory SingleRoomListModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return SingleRoomListModel(
      count: json['count'],
      singleRoomList: json["data"]
          .map<SingleRoomModel>(
            (x) => SingleRoomModel.fromJson(json: x),
      ).toList(),
    );
  }
}

class SingleRoomModel{
  final String createdAt;
  final int mid1;
  final int mid2;
  final int id;

  SingleRoomModel({
    required this.createdAt,
    required this.mid1,
    required this.mid2,
    required this.id,
  });

  factory SingleRoomModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return SingleRoomModel(
      createdAt: json['created_at'],
      mid1: json['mid1'],
      mid2: json['mid2'],
      id: json['id'],
    );
  }
}