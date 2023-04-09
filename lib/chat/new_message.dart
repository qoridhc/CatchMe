import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _controller = TextEditingController();
  var _userEnterMessage = '';
  void _sendMessage() async{ // 보내기 버튼 클릭하면 키보드에서 초점 나가게
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser; // firebase에서 제공하는 user정보
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text' : _userEnterMessage,
      'time' : Timestamp.now(), // timestamp는 firebase에서 제공하는 기능
      'userID' : user!.uid,
      'userName' : userData.data()!['userName'],
      'userImage' : userData['picked_image']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(
                  labelText: 'Send a message...'
              ),
              onChanged: (value){
                setState(() { // 이렇게 설정하면 변수에다가 입력된 값이 바로바로 들어가기 때문에 send 버튼 활성화,비활성화 설정가능
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton( // 텍스트 입력창에 텍스트가 입력되어 있을때만 활성화 되게 설정
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,  // 만약 메세지 값이 비어있다면 null을 전달하여 비활성화하고 값이 있다면 활성화시킴
            icon: Icon(Icons.send), // 보내기 버튼
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

