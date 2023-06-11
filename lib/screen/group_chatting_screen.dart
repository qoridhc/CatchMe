import 'dart:async';
import 'dart:convert';
import 'package:captone4/chat/message.dart';
import 'package:captone4/chat/new_message.dart';
import 'package:captone4/provider/time_provider.dart';
import 'package:captone4/screen/chat_room_list_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      {required this.createTime,
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
        ));
  }
}

class _GroupChattingScreenState extends ConsumerState<GroupChattingScreen> {
  late int _memberId;
  late String _memberToken;
  late String senderImage;
  late String senderGender;
  late GroupRoomModel groupRoomModel;
  var _userEnterMessage = '';

  bool _visibility = true;
  late Timer _timer;
  Duration? timeDiff = null;
  int time = 0;
  int defaultTime = 900;
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
        CHATTING_API_URL +
            '/api/v1/group_records?groupId=${widget.roomData!.id.toString()}',
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

    (anonymousFemale.values.elementAt(0) == -1) ? callRender() : Container();

    if (widget.createTime != null) {
      timeDiff = DateTime.now().difference(widget.createTime!);

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
    _stompClient.activate();
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

    setState(() {
      _stompClient.send(
        // headers: {"auto-delete": "false", "id": "${_memberId}", "durable": "true"},
        destination: '/app/chat.enter.Multi' + widget.roomData!.id.toString(),
        // Spring Boot 서버의 메시지 핸들러 엔드포인트 경로  abc방에 보낸다
        body: body,
      );
    });

    print("전송!");

    scrollListToEnd();
    messageController.clear();
    _userEnterMessage = '';
  }

  void scrollListToEnd() {
    if (scrollMax) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stompClient.deactivate();
    if (_stompClient.isActive) {
      _stompClient.deactivate();
    }
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

  // sender 정보 얻기
  Future<MemberModel> getSenderInfo(int senderId, int index) async {
    print("Get user's information");
    final dio = Dio();

    try {
      final getUser = await dio.get(
        CATCHME_URL + '/api/v1/members/${senderId}',
        options: Options(
          headers: {'authorization': 'Bearer ${_memberToken}'},
        ),
      );
      print('멤버와 관련된 정보 ${MemberModel.fromJson(json: getUser.data).gender}');
      if (index == 5) {
        if (anonymousFemale.length == 3) {
          anonymousMale[anonymousMale.keys.last] = senderId;
// snapshot.data!.memberId as int;
// return Container();
        } else {
          anonymousFemale[anonymousFemale.keys.last] = senderId;
// snapshot.data!.memberId as int;
// return Container();
        }
      } else {
        if (senderGender == 'M') {
          anonymousMale.forEach(
            (key, value) {
              if (value == -1) {
                anonymousMale[key] = senderId;
// anonymousMale[key] = snapshot.data!.memberId as int;
                debugPrint(anonymousMale.toString());
                return;
              }
            },
          );
        } else {
          anonymousFemale.forEach(
            (key, value) {
              if (value == -1) {
                anonymousFemale[key] = senderId;
                print(anonymousFemale.toString());
                return;
              }
            },
          );
        }
      }
      return MemberModel.fromJson(json: getUser.data);
    } on DioError catch (e) {
      print('error: $e');
      throw e;
    }
  }

// 제리를 제외한 유저들을 아래 맵들에 성별 구분해서 넣으려고 함.
  var anonymousMale = {'남자 1호': -1, '남자 2호': -1, '남자 3호': -1};
  var anonymousFemale = {'여자 1호': -1, '여자 2호': -1, '여자 3호': -1};

  Widget renderSenderInfoBuild({required int senderId, required int index}) {
    print('renderSenderInfoBuild 실행');
    print('senderId $senderId index $index');
    return Container(
      child: FutureBuilder<MemberModel>(
        future: getSenderInfo(senderId, index),
        builder: (_, AsyncSnapshot<MemberModel> snapshot) {
          print('builder까지 성공~!');
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data!.gender != null) {
            debugPrint('데이터 1개 이상 있음');
            debugPrint('$senderId 성별 ${snapshot.data!.gender}');
            senderGender = snapshot.data!.gender;
            if (index == 5) {
              if (anonymousFemale.length == 3) {
                anonymousMale[anonymousMale.keys.last] =
                    snapshot.data!.memberId as int;
                return Container();
              } else {
                anonymousFemale[anonymousFemale.keys.last] =
                    snapshot.data!.memberId as int;
                return Container();
              }
            } else {
              if (senderGender == 'M') {
                anonymousMale.forEach(
                  (key, value) {
                    if (value == -1) {
                      anonymousMale[key] = snapshot.data!.memberId as int;
                      debugPrint(anonymousMale.toString());
                      return;
                    }
                  },
                );
              } else {
                anonymousFemale.forEach(
                  (key, value) {
                    if (value == -1) {
                      anonymousFemale[key] = snapshot.data!.memberId as int;
                      print(anonymousFemale.toString());
                      return;
                    }
                  },
                );
              }
            }
            debugPrint('익명 남자 리스트 $anonymousMale');
            debugPrint('익명 여자 리스트 $anonymousFemale');
            return _buildAppBar();
          }
          return const Center(
            child: Text("There's no such information."),
          );
        },
      ),
    );
  }

  void callRender() {
    var realUsers = [
      widget.roomData?.mid1,
      widget.roomData?.mid2,
      widget.roomData?.mid3,
      widget.roomData?.mid4,
      widget.roomData?.mid5,
      widget.roomData?.mid6,
// widget.roomData?.jerry_id
    ];
    var jerryId = widget.roomData!.jerry_id;
// 재정렬할 리스트
    var rearrangeList = [];

    for (int i = 0; i < 6; i++) {
      if (jerryId != realUsers[i]) {
        rearrangeList.add(realUsers[i]);
      } else {
        rearrangeList.insert(0, jerryId);
      }
    }

// 제리를 리스트 맨 뒤에위치하기 위한 조건문
    int indexToMove = 0;
    if (indexToMove >= 0 && indexToMove < rearrangeList.length) {
      int elementToMove = rearrangeList.removeAt(indexToMove)
          as int; // 제리 아이디가 인덱스 0에 있으니 설정 쉽게 하기 위해 제거
      rearrangeList.add(elementToMove); // 제리를 리스트의 맨 뒤에 추가
    }
    print('재정렬한 리스트 $rearrangeList');

    renderSenderInfoBuild(senderId: rearrangeList[0], index: 0);
    renderSenderInfoBuild(senderId: rearrangeList[1], index: 1);
    renderSenderInfoBuild(senderId: rearrangeList[2], index: 2);
    renderSenderInfoBuild(senderId: rearrangeList[3], index: 3);
    renderSenderInfoBuild(senderId: rearrangeList[4], index: 4);
    renderSenderInfoBuild(senderId: rearrangeList[5], index: 5);
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
    ScrollController _scrollController = ScrollController();
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

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        });

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: chattingHistoryListModel.count,
                          itemBuilder: (context, index) {
                            return ChatBubbles(
                              chatHistoryList[index].message,
                              chatHistoryList[index].sender ==
                                  _memberId.toString(),
                              chatHistoryList[index].sender.toString() !=
                                      _memberId.toString()
                                  ? "fdas"
                                  : "Asdf",
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
