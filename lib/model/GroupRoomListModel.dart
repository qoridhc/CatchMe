class GroupRoomListModel {
  final count;
  final List<GroupRoomModel>? groupRoomList;

  GroupRoomListModel({required this.count, required this.groupRoomList});

  factory GroupRoomListModel.fromJson({required Map<String, dynamic> json}) {
    return GroupRoomListModel(
        count: json['count'],
        groupRoomList: json['data']
            .map<GroupRoomModel>(
              (x) => GroupRoomModel.fromJson(json: x),
            )
            .toList());
  }
}

class GroupRoomModel {
  final DateTime createAt;
  final int mid1;
  final int mid2;
  final int mid3;
  final int mid4;
  final int mid5;
  final int mid6;
  final int jerry_id;
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
    required this.staus,
    required this.jerry_id,
  });

  factory GroupRoomModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    DateTime time = DateTime(1);

    print("json['created_at'].runtimeType = ${json['created_at'].runtimeType}");
    print(
        "json['created_at'].runtimeType is List<dynamic> = ${json['created_at'].runtimeType.toString() == "List<dynamic>"}");

    var serverTime = json['created_at'];

    if (json['created_at'].runtimeType.toString() == "List<dynamic>") {
      print("isTrue");

      time = DateTime.parse(
        "${serverTime[0]}-${serverTime[1].toString().padLeft(2, '0')}-${serverTime[2].toString().padLeft(2, '0')} ${serverTime[3].toString().padLeft(2, '0')}:${serverTime[4].toString().padLeft(2, '0')}:${serverTime[5].toString().padLeft(2, '0')}.${serverTime[6]}"
      );

      print("parseTime = $time");
      // String stringTime = json['created_at'].join('.');
      // print("stringTime = $stringTime");
      // time = DateTime.parse(stringTime);
      // print("listtime = $time");
    } else {
      time = DateTime.parse(json['created_at'].toString());
      print("time = $time");
    }

    return GroupRoomModel(
        createAt: time,
        mid1: json['mid1'],
        // ?? 0 붙이면 될수도
        mid2: json['mid2'],
        mid3: json['mid3'],
        mid4: json['mid4'],
        mid5: json['mid5'],
        mid6: json['mid6'],
        id: json['id'],
        staus: json['status'],
        jerry_id: json['jerry_id']);
  }
}
