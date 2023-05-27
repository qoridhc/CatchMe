import 'package:captone4/chat/chat_bubble.dart';
import 'package:flutter/material.dart';


class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      'tester'
    ];
    final List<String> _userID = <String>[
      '아이유',
      '차은우',
      '배수지',
      '김민주',
      '조유리',
      'test'
    ];
    final List<String> _text = <String>[
      '안녕하세요 아이유입니다',
      '안녕하세요 차은우입니다',
      '안녕하세요 배수지입니다',
      '안녕하세요 김민주입니다',
      '안녕하세요 조유리입니다',
      '안녕하세요 테스터입니다',
    ];

    return ListView.builder(
      itemCount: _name.length, // 데이터가 null값이면 안되기에
      itemBuilder: (context, index) {
        return ChatBubbles(_text[index],
            _userID[index] == userID,
            _name[index],
            _img[index]
        ); // chat bubble 안에 메세지들을 넣어준다
      },
    );
  }
}
