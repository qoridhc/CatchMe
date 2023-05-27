import 'dart:async';
import 'package:captone4/chat/message.dart';
import 'package:captone4/chat/new_message.dart';
import 'package:captone4/provider/time_provider.dart';
import 'package:captone4/screen/chat_room_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _visibility = true;
  int sec = 60;
  int min = 3;
  String secText = '00';
  String minText = '3';
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleTimer();
    if(!ref.read(TimerProvider.notifier).isRun)
      ref.read(TimerProvider.notifier).start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");

    ref.read(TimerProvider.notifier).cancel();
    ref.read(TimerProvider.notifier).pause();

  }

  void _handleTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if(min >= 3){
          min--;
          sec--;
        }else{
          if(sec == 60){
            min--;
          }
          sec--;
        }

        if(sec > 9){
          secText = '$sec';
        }else{
          if(sec > 0){
            secText = '0$sec';
          } else {
            sec = 60;
            secText = '00';
          }
        }

        if(min > 9){
          minText = '$min';
        }else{
          if(min > 0){
            minText = '0$min';
          } else {
            minText = '00';
            if(sec == 60){
              _timer?.cancel();
              _visibility = false;
            }
          }
        }
      });
    });
  }

  AppBar _buildAppBar(int time){
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
            gradient: LinearGradient(colors: [
              Color(0xffFF6961),
              Color(0xffFF6961),
              Color(0xffFF6961),
              Color(0xffFF6961),
            ],
            )
        ),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
              child: InkWell(
                child: SizedBox(
                  width: getMediaWidth(context)*0.1,
                  height: getMediaHeight(context)*0.1,
                  child: CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/images/test_img/조유리.jpg'),
                  ),
                ),
              ),
            ), // 채팅창 앱바 프로필 사진 파트
            Container(
              width: getMediaWidth(context)*0.5,
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
              child: Row(
                children: [
                  SizedBox(
                    width: getMediaWidth(context)*0.2,
                    height: getMediaHeight(context)*0.04,
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
                                fontSize: 16),
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
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                  Text(
                    "${time % 60}",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15),
                  )
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

    final time = ref.watch(TimerProvider);
    print(time);

    return Scaffold(
      appBar: _buildAppBar(time),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            Visibility(child: NewMessage(),
            visible: _visibility,)
            ,
          ],
        ),
      ),
    );
  }
}
