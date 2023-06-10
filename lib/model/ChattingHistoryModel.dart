class ChattingHistoryListModel{
  final count;
  final List<ChattingHistory>? chattingHistory;

  ChattingHistoryListModel({
    required this.count,
    required this.chattingHistory,
  });

  factory ChattingHistoryListModel.fromJson({
    required Map<String, dynamic> json
  }){
    return ChattingHistoryListModel(
        count: json['count'],
        chattingHistory: json['data'].map<ChattingHistory>(
            (x) => ChattingHistory.fromJson(json: x),
        ).toList(),
    );
  }
}

class ChattingHistory{
  final int id;
  final String type;
  final String roomId;
  final String sender;
  final String message;
  final String roomType;
  final String send_time;


  ChattingHistory({
    required this.id,
    required this.type,
    required this.roomId,
    required this.sender,
    required this.message,
    required this.roomType,
    required this.send_time,
  });

  factory ChattingHistory.fromJson({
    required Map<String, dynamic> json,
  }) {
    return ChattingHistory(
        id: json['id'],
        type: json['type'],
        roomId: json['roomId'],
        sender: json['sender'],
        message: json['message'],
        roomType: json['roomType'],
        send_time: json['send_time'],
    );
  }
}