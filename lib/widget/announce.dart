import 'package:captone4/widget/default_layout.dart';
import 'package:captone4/widget/shrink_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Announce extends StatefulWidget {
  // late final String content;
  Announce({Key? key}) : super(key: key);
  // Announce({required this.content});

  @override
  State<Announce> createState() => _AnnounceState();
}

late AnimationController _controller;
bool clicked = false;
var users = ['여자 1호', '여자 2호', '여자 3호', '남자 1호', '남자 2호'];

class _AnnounceState extends State<Announce> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var customHeight = MediaQuery.of(context).size.height / 10;
    var customWidth = (MediaQuery.of(context).size.width * 7 / 8) / 2;
    late var boxColor = Colors.red[400];

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
    }

    return DefaultLayout(
      child: SafeArea(
        child: ExpansionTile(
          title: Row(
            children: const [
              Text('마피아에게 투표해주세요!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
            ],
          ),
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShrinkButton(onPressed: () {}, userName: users[0]),
                        ShrinkButton(onPressed: () {}, userName: users[1]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShrinkButton(onPressed: () {}, userName: users[2]),
                        ShrinkButton(onPressed: () {}, userName: users[3]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShrinkButton(onPressed: () {}, userName: users[4]),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('유저네임를 마피아로 투표하셨습니다'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Icon(Icons.check_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
