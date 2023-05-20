import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.userName, this.userImage, {Key? key})
      : super(key: key);

  final String message; // 메세지 내용을 받아와서 이 변수에 저장
  final bool isMe;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Row(
            // Row로 감싸야지 챗버블이 가로길이를 전체차지하지 않음
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 20),
                    backGroundColor: Color(0xffFF9494),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
                    backGroundColor: Color(0xffD9D9D9),
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black
                            ),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            top: 0,
            right: isMe ? 5 : null,
            left: isMe ? null : 5,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
          ),
        ]
    );
  }
}
