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
  final DateTime makeTime;
  final int mid1;
  final int mid2;
  final int Roomid;

  SingleRoomModel({
    required this.makeTime,
    required this.mid1,
    required this.mid2,
    required this.Roomid,
  });

  factory SingleRoomModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return SingleRoomModel(
      makeTime: json['makeTime'],
      mid1: json['memberID1'],
      mid2: json['memberID2'],
      Roomid: json['RoomID'],
    );
  }
}