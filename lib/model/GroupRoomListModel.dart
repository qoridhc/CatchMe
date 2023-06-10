class GroupRoomListModel{
  final count;
  final List<GroupRoomModel>? groupRoomList;

  GroupRoomListModel({
    required this.count,
    required this.groupRoomList
  });

  factory GroupRoomListModel.fromJson({
    required Map<String, dynamic> json
  }){
    return GroupRoomListModel(
        count: json['count'],
        groupRoomList: json['groupRoomList']
        .map<GroupRoomModel>(
            (x) => GroupRoomModel.fromJson(json: x),
        ).toList()
    );
  }
}

class GroupRoomModel{
  final String createAt;
  final int mid1;
  final int mid2;
  final int mid3;
  final int mid4;
  final int mid5;
  final int mid6;

  final int id;

  final bool staus;

  GroupRoomModel({
      required this.createAt,
      required this.mid1,
      required this.mid2,
      required this.mid3,
      required this.mid4,
      required this.mid5,
      required this.mid6,
      required this.id,
      required this.staus
  });

  factory GroupRoomModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return GroupRoomModel(
        createAt: json['created_at'],
        mid1: json['mid1'] ,// ?? 0 붙이면 될수도
        mid2: json['mid2'],
        mid3: json['mid3'],
        mid4: json['mid4'],
        mid5: json['mid5'],
        mid6: json['mid6'],
        id: json['id'],
        staus: json['status']
    );
  }
}