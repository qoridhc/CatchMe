import 'dart:async';
import 'package:captone4/chat/message.dart';
import 'package:captone4/chat/new_message.dart';
import 'package:captone4/screen/chat_room_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  AppBar _buildAppBar(){
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
                  width: 44,
                  height: 44,
                  child: CircleAvatar(
                    backgroundImage:
                    AssetImage('assets/images/test_img/조유리.jpg'),
                  ),
                ),
              ),
            ), // 채팅창 앱바 프로필 사진 파트
            Container(
              width: 200,
              padding: EdgeInsets.only(top: 0, bottom: 0, right: 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 30,
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
                    width: 70,
                  ),
                  Text(
                    minText,
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  Text(
                    ':',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  Text(
                    secText,
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
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
    return Scaffold(
      appBar: _buildAppBar(),
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
