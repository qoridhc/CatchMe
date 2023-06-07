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
import '../model/member_model.dart';

class SingleChattingScreen extends ConsumerStatefulWidget {
  final Token? token;

  int? roomNum;


  SingleChattingScreen({
      required this.roomNum,
      Key? key,
      @required this.token
  }) : super(key: key);

  @override
  ConsumerState<SingleChattingScreen> createState() => _SingleChattingScreenState();
}

class ChatMessage {
  String? type;
  String? roomId;
  String? sender;
  String? message;
  String? roomType;

  ChatMessage(
      {required this.type,
      required this.roomId,
      required this.sender,
      required this.message,
      required this.roomType});
}

class _SingleChattingScreenState extends ConsumerState<SingleChattingScreen> {
  late int _memberId;
  late String _memberToken;
  late String senderImage;
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

  String userID = "test";
  final List<String> _img = <String>[
    'assets/images/test_img/1.jpg',
    'assets/images/test_img/2.jpg',
    'assets/images/test_img/3.jpg',
    'assets/images/test_img/김민주.jpg',
    'assets/images/test_img/조유리.jpg',
    'assets/images/test_img/5.jpg',
  ];
  final List<String> _name = <String>[
    '아이유',
    '차은우',
    '배수지',
    '김민주',
    '조유리',
    'tester',
  ];
  final List<String> _userID = <String>[
    '아이유',
    '차은우',
    '배수지',
    '김민주',
    '조유리',
    'test',
  ];
  final List<String> _text = <String>[
    '안녕하세요 아이입니다',
    '안녕하세요 차은우입니다',
    '안녕하세요 배수지입니다',
    '안녕하세요 김민주입니다',
    '안녕하세요 조유리입니다',
    '안녕하세요 테스터입니다',
  ];

  late Token _token;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();

    _memberId = widget.token!.id!;
    _memberToken = widget.token!.accessToken!;

    if (widget.createTime != null) {
      timeDiff = DateTime.now().difference(widget.createTime!);
      print("now : ${DateTime.now()}");
      print("timeDiff : $timeDiff");
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
    // if(!ref.read(TimerProvider.notifier).isRun)
    //   ref.read(TimerProvider.notifier).start();
    DateTime room0CreateTime = DateTime.now(); // 임시로 현재 시간을 채팅방0 생성 시간으로 설정
    roomCreateTimeList.add(room0CreateTime); // 시간 리스트에 저장

    //channel = IOWebSocketChannel.connect('ws://10.0.2.2:9081/chat');
    // _stompClient = widget.stompClient!;

    // _stompClient.deactivate();
    connectToStomp(); //stomp 연결
    print("웹 소캣 연결");

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // 위젯이 빌드되고 난 후 스크롤 위치를 설정합니다.
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void connectToStomp() {
    // _stompClient.config.onConnect;
    // _stompClient.subscribe(//메세지 서버에서 받고 rabbitmq로 전송
    //     destination: '/topic/room.abc', // 구독할 주제 경로  abc방을 구독
    //     callback: (connectFrame) {
    //       print(connectFrame.body); //메시지를 받았을때!
    //       // 메시지 처리
    //       }
    //     );
    _stompClient = StompClient(
        config:  StompConfig(
          url: 'ws://localhost:9081/chat', // Spring Boot 서버의 WebSocket URL
          onConnect: onConnectCallback,
       )// 연결 성공 시 호출되는 콜백 함수
      );
    print("chating 연결성공");
  }

  void onConnectCallback(StompFrame connectFrame) { //decoder, imgurl 앞에서 받아올것
    _stompClient.subscribe(
      //메세지 서버에서 받고 rabbitmq로 전송
      destination: '/topic/room.single' + 1.toString(), // 구독할 주제 경로  abc방을 구독
      callback: (connectFrame) {
        print(connectFrame.body); //메시지를 받았을때!
        String? talk = connectFrame.body;
        _token = Token.fromJson(json.decode(talk!)); // 여기 고쳐야함
        String text =
            connectFrame.body!.substring(1, connectFrame.body!.length - 1);
        _text.add(text);
        _name.add("sss");
        _userID.add("sss");
        _img.add('assets/images/test_img/조유리.jpg');
        // 메시지 처리
      },
    );
  }

  void sendMessage() {
    //encoder
    FocusScope.of(context).unfocus();
    String message = messageController.text;
    var body = json.encode(ChatMessage(
        type: "TALK",
        roomId: widget.roomNum.toString(),
        sender: _memberId.toString(),
        message: message,
        roomType: "Single"));
    _stompClient.send(
      destination: '/app/chat.enter.abc',
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

  // sender 정보 얻기
  Future<MemberModel> getSenderInfo() async {
    print("Get user's information");
    final dio = Dio();

    try {
      final getGender = await dio.get(
        'http://$ip/api/v1/members/${_memberId}',
        options: Options(
          headers: {'authorization': 'Bearer ${_memberToken}'},
        ),
      );
      return MemberModel.fromJson(json: getGender.data);
    } on DioError catch (e) {
      print('error: $e');
      rethrow;
    }
  }

  // senderImage를 _img에 넣음
  Widget renderSenderInfoBuild() {
    return Container(
      child: FutureBuilder<MemberModel>(
        future: getSenderInfo(),
        builder: (_, AsyncSnapshot<MemberModel> snapshot) {
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
            if (snapshot.data!.imageUrls != null) {
              senderImage = snapshot.data!.imageUrls as String;
              _img.add(senderImage);
              // 위젯만 리턴할 수 있어서 우선 아무거나 넣음
              return _buildAppBar();
            } else {
              // 위젯만 리턴할 수 있어서 우선 아무거나 넣음
              return _buildAppBar();
            }
          } else {
            return const Center(
              child: Text("There's no such information."),
            );
          }
        },
      ),
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
                        AssetImage('assets/images/test_img/조유리.jpg'),
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
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _name.length,
                // 데이터가 null값이면 안되기에 여기에 해당 톡방에 쌓여있는 문자들 수 들어갈 수 있게
                itemBuilder: (context, index) {
                  scrollListToEnd();
                  scrollMax = false;
                  return ChatBubbles(_text[index], _userID[index] == userID,
                      _name[index], _img[index]);
                  // chat bubble 안에 메세지들을 넣어준다
                },
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
