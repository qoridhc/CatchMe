import 'package:captone4/screen/chatting_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widget/default_layout.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Catch Me',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Pacifico', fontSize: 40, color: Colors.white),
      ),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      elevation: 0,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        children: [
          SizedBox(
            height: 60,
          ),
          Container(
              height: 50,
              color: Colors.white,
              child: const Center(child: Text('예시입니당'))),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 0, bottom: 0, left: 20),
                    child: InkWell(
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/id/421/200/200',
                          imageBuilder: (context, imageProvider) => Container(
                            height: 44,
                            width: 44,
                            margin: null,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(44)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover)),
                          ),
                          errorWidget: (context, url, error) => Image(
                              image: AssetImage('../image/chat_back.jpg')),
                        ),
                      ),
                    ),
                  ), // 채팅창 앱바 프로필 사진 파트
                  Container(
                    width: 180,
                    padding: EdgeInsets.only(top: 0, bottom: 0, left: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,MaterialPageRoute(builder: (context)=>const ChatScreen()),
                              );
                            },
                            child: Text(
                              'user이름',
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              color: Colors.white,
              child: const Center(child: Text('예시입니당')))
        ],
      ),
    );
  }
}
