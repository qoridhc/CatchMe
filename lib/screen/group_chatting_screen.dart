import 'dart:async';
import 'dart:convert';
import 'package:captone4/chat/message.dart';
import 'package:captone4/chat/new_message.dart';
import 'package:captone4/provider/time_provider.dart';
import 'package:captone4/screen/chat_room_list_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../Token.dart';
import '../chat/chat_bubble.dart';
import '../const/data.dart';
import '../model/ChattingHistoryModel.dart';
import '../model/GroupRoomListModel.dart';
import '../model/member_model.dart';

class GroupChattingScreen extends ConsumerStatefulWidget {
  final Token? token;
  final GroupRoomModel? roomData;
  DateTime? createTime;


  GroupChattingScreen(
      {
        required this.createTime,
        required this.roomData,
        Key? key,
        @required this.token})
      : super(key: key);

  @override
  ConsumerState<GroupChattingScreen> createState() =>
      _GroupChattingScreenState();
}

class ChatMessage {
  String? type;
  String? roomId;
  String? sender;
  String? message;
  String? roomType;

  Map<String, dynamic> toJson() => {
    'type': type,
    'roomId': roomId,
    'sender': sender,
    'message': message,
    'roomType': roomType,
  };

  ChatMessage(
      {required this.type,
        required this.roomId,
        required this.sender,
        required this.message,
        required this.roomType});

  factory ChatMessage.fromJson({required Map<String, dynamic> json}) {
    return ChatMessage(
        type: json['type'],
        roomId: json['roomId'],
        sender: json['sender'],
        message: json['message'],
        roomType: json['roomType'].map<ChatMessage>(
              (x) => ChatMessage.fromJson(json: x),
        )
    );
  }
}

class _GroupChattingScreenState extends ConsumerState<GroupChattingScreen> {
  late int _memberId;
  late String _memberToken;
  late String senderImage;
  late GroupRoomModel groupRoomModel;
  var _userEnterMessage = '';

  bool _visibility = true;
  late Timer _timer;
  Duration? timeDiff = null;
  int time = 0;
  int defaultTime = 3000;
  bool scrollMax = false;

  late StompClient _stompClient;

  TextEditingController messageController = TextEditingController();
  List<DateTime> roomCreateTimeList = [];
  late ScrollController _scrollController;

  List<ChattingHistory> chatHistoryList = [];

  late Token _token;

  Future<ChattingHistoryListModel> getGroupChatRecord() async {
    print("Get chat record's information");
    final dio = Dio();

    try {
      final response = await dio.get(
        CHATTING_API_URL + '/api/v1/group_records?groupId=${widget.roomData!.id.toString()}',
      );
      return ChattingHistoryListModel.fromJson(json: response.data);
    } on DioError catch (e) {
      print('error: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();

    _memberId = widget.token!.id!;
    _memberToken = widget.token!.accessToken!;

    if (widget.createTime != null) {
      timeDiff =
          DateTime.now().difference(widget.createTime!);

      setState(
            () {
          if ((defaultTime - timeDiff!.inSeconds) > 0) {
            time = defaultTime - timeDiff!.inSeconds;
          } else {
            _visibility = false;
          }
        },
      );
    }

    _handleTimer();

    DateTime room0CreateTime = DateTime.now(); // 임시로 현재 시간을 채팅방0 생성 시간으로 설정
    roomCreateTimeList.add(room0CreateTime); // 시간 리스트에 저장

    connectToStomp(); //stomp 연결
    print("웹 소캣 연결");

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // 위젯이 빌드되고 난 후 스크롤 위치를 설정합니다.
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
  }

  void connectToStomp() {
    _stompClient = StompClient(
        config: StompConfig(
          url: CHATTING_WS_URL, // Spring Boot 서버의 WebSocket URL
          onConnect: onConnectCallback,
        ) // 연결 성공 시 호출되는 콜백 함수
    );
    print("chating 연결성공");
  }

  void onConnectCallback(StompFrame connectFrame) {
    //decoder, imgurl 앞에서 받아올것
    _stompClient.subscribe(
      //메세지 서버에서 받고 rabbitmq로 전송
      destination: '/topic/room.Multi' + widget.roomData!.id.toString(),
      headers: {"auto-delete": "true"},
      callback: (connectFrame) {
        print("connectFrame.body 출력 :");
        print(connectFrame.body); //메시지를 받았을때!
        setState(() {
          Map<String, dynamic> chat =
          (json.decode(connectFrame.body.toString()));

          ChatMessage? chatMessage;
          chatMessage?.type = chat["type"];
          chatHistoryList.add(ChattingHistory(
            id: chatHistoryList.last.id + 1,
            type: "TALK",
            roomId: widget.roomData!.id.toString(),
            sender: chat["sender"],
            message: chat["message"],
            roomType: "Multi",
            send_time: DateTime.now().toString(),
          ));

          chatMessage?.roomId = chat["roomId"];
          /*_name.add(chat["sender"] != _memberId.toString()
              ? widget.nickname
              : memberState.nickname);
          _sender.add(chat["sender"]);*/
          chatMessage?.roomType = chat["roomType"];

          scrollListToEnd();
        });
      },
    );
  }

  void sendMessage() {
    //encoder
    FocusScope.of(context).unfocus();
    String message = messageController.text;
    print("body출력");
    print(widget.roomData!.id.toString());

    ChatMessage chatMessage = ChatMessage(
        type: "TALK",
        roomId: widget.roomData!.id.toString(),
        sender: _memberId.toString(),
        message: message,
        roomType: "Multi");
    print(chatMessage);
    var body = json.encode(chatMessage);
    print(body);

    _stompClient.send(
      destination: '/app/chat.enter.Multi' + widget.roomData!.id.toString(),
      // Spring Boot 서버의 메시지 핸들러 엔드포인트 경로  abc방에 보낸다
      body: body,
    );
    print("전송!");

    scrollMax = true;
    scrollListToEnd();
    messageController.clear();
    _userEnterMessage = '';
  }

  void scrollListToEnd() {
    if (scrollMax) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stompClient.deactivate();
    super.dispose();
    if (_timer.isActive) _timer.cancel();
    print("dispose");

    // ref.read(TimerProvider.notifier).cancel();
    // ref.read(TimerProvider.notifier).pause();
  }

  void _handleTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
          (timer) {
        setState(() {
          if (time <= 0) {
            _visibility = false;
            _timer.cancel();
          } else {
            time = time - 1;
          }
        });
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(
            Icons.exit_to_app_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            ChatRoomScreen();
          },
        )
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFF6961),
                Color(0xffFF6961),
                Color(0xffFF6961),
                Color(0xffFF6961),
              ],
            )),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
              child: InkWell(
                child: SizedBox(
                  width: getMediaWidth(context) * 0.1,
                  height: getMediaHeight(context) * 0.1,
                  child: CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/images/information_image.png'),
                  ),
                ),
              ),
            ), // 채팅창 앱바 프로필 사진 파트
            Container(
              width: getMediaWidth(context) * 0.5,
              padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0),
              child: Row(
                children: [
                  SizedBox(
                    width: getMediaWidth(context) * 0.2,
                    height: getMediaHeight(context) * 0.04,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: [
                          Text(
                            '채팅방',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getMediaWidth(context) * 0.1,
                  ),
                  Text(
                    "${(time / 60).toInt()}",
                    style: const TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    (time % 60).toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _stompClient.activate();
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: FutureBuilder<ChattingHistoryListModel>(
                  future: getGroupChatRecord(),
                  builder:
                      (_, AsyncSnapshot<ChattingHistoryListModel> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data! != 0) {
                      // return _renderSingleRoomListView(snapshot.data!, indexNum);
                      ChattingHistoryListModel chattingHistoryListModel =
                      snapshot.data!;

                      if (chattingHistoryListModel.count != 0) {
                        chatHistoryList =
                            List.from(snapshot.data!.chattingHistory!.reversed);

                        return ListView.builder(
                          itemCount: chattingHistoryListModel.count,
                          itemBuilder: (context, index) {
                            return ChatBubbles(
                              chatHistoryList[index].message,
                              chatHistoryList[index].sender == _memberId.toString(),
                              chatHistoryList[index].sender.toString() != _memberId.toString() ? "fdas" : "Asdf",
                              "https://aws-s3-catchme.s3.ap-northeast-2.amazonaws.com/20230608/"
                                  "z2geqehuje_1686184911395.jpg",
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("해당 정보가 없습니다."),
                        );
                      }
                    } else {
                      return Center(
                        child: Text("해당 정보가 없습니다."),
                      );
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: _visibility,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        controller: messageController,
                        decoration: const InputDecoration(
                            labelText: 'Send a message...'),
                        onChanged: (value) {
                          setState(() {
                            // 이렇게 설정하면 변수에다가 입력된 값이 바로바로 들어가기 때문에 send 버튼 활성화,비활성화 설정가능
                            _userEnterMessage = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      // 텍스트 입력창에 텍스트가 입력되어 있을때만 활성화 되게 설정
                      onPressed:
                      _userEnterMessage.trim().isEmpty ? null : sendMessage,
                      // 만약 메세지 값이 비어있다면 null을 전달하여 비활성화하고 값이 있다면 활성화시킴
                      icon: const Icon(Icons.send),
                      // 보내기 버튼
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
