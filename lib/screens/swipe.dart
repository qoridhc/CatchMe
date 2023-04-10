import 'package:captone4/screens/swipe_card.dart';
import 'package:captone4/models/user.dart';
import 'package:flutter/material.dart';

class Swipe extends StatefulWidget {
  Swipe({super.key});

  @override
  State<Swipe> createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  final List<String> imgList = [
    'assets/images/suzy1.jpg',
    'assets/images/suzy2.jpg',
    'assets/images/suzy3.jpg',
  ];

  List<User> users = [
    User(
      name: '배수지',
      photo: 'assets/images/suzy1.jpg',
      age: 28,
      mbti: 'INFP',
      status: 'Relationship',
      info:
          "Hello I'm suzy. \nI'm little introvert but I'm very funny when I get familiar with new friends!\nI'm looking forward to meet my future boyfriend in here.",
    ),
    User(
      name: '고윤정',
      photo: 'assets/images/go.jpg',
      age: 26,
      mbti: 'ISTP',
      status: 'Something Casual',
      info:
          "Hey im Yunjeong \nI just want just friend not deep relationship.\nSWIPE ME",
    ),
    User(
      name: '박지현',
      photo: 'assets/images/jihyun.jpg',
      age: 28,
      mbti: 'INFP',
      status: 'Don\'t know yet',
      info: '',
    ),
  ];

  Color _backgroundColor = Colors.white;
  int currentIndex = 0;

  void _swipeLeft() {
    setState(() {
      _backgroundColor = Colors.blue;
    });
  }

  void _swipeRight() {
    setState(() {
      _backgroundColor = Theme.of(context).primaryColor;
    });
  }

  void returnColor() {
    setState(() {
      _backgroundColor = Colors.white;
    });
  }

  void updateIndex(int index) {
    setState(() {
      currentIndex = index % users.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(currentIndex >= 0 && currentIndex < users.length
          ? users[currentIndex]
          : null),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        setState(() {
          users.removeAt(currentIndex);
          if (currentIndex == users.length) {
            currentIndex = 0;
          }
        });
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < -10) {
            // Handle swiping to the left
            // _swipeLeft();
            updateIndex(currentIndex + 1);
          } else if (details.delta.dx > 10) {
            // Handle swiping to the right
            // _swipeRight();
            updateIndex(currentIndex + 1);
          } else {
            // returnColor();
          }
        },

        // child: SwipeCard(
        child: SwipeCard(
          imgUrl: users[currentIndex].data?['photo'],
          userName: users[currentIndex].data?['name'],
          userAge: users[currentIndex].data?['age'],
          userMbti: users[currentIndex].data?['mbti'],
          userStatus: users[currentIndex].data?['status'],
          userInfo: users[currentIndex].data?['info'],
          backColor: _backgroundColor,
        ),
      ),
    );
  }
}
