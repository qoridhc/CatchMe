import 'dart:async';
import 'package:captone4/chat/message.dart';
import 'package:captone4/chat/new_message.dart';
import 'package:captone4/provider/time_provider.dart';
import 'package:captone4/screen/chat_room_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  DateTime? createTime;

  ChatScreen({
    required this.createTime,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _visibility = true;
  int sec = 60;
  int min = 3;
  String secText = '00';
  String minText = '3';
  late Timer _timer;
  Duration? timeDiff = null;
  int time = 0;
  int defaultTime = 900;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("creatTime : ${widget.createTime}");

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                        AssetImage('assets/images/test_img/조유리.jpg'),
                  ),
                ),
              ),
            ), // 채팅창 앱바 프로필 사진 파트
            Container(
              width: getMediaWidth(context) * 0.5,
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
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
                    width: getMediaWidth(context)*0.1,
                  ),
                  Text(
                    "${(time / 60).toInt()}",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
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
                    style: TextStyle(
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
    //
    // final time = ref.watch(TimerProvider);
    // print(time);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            Visibility(
              child: NewMessage(),
              visible: _visibility,
            ),
          ],
        ),
      ),
    );
  }
}
