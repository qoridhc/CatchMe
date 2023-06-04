import 'package:flutter/material.dart';

import '../const/colors.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('매칭 중...',
                  style: TextStyle(
                      fontFamily: 'Pacifico', fontSize: 15),)
              ],
            ),
          ),
        );
      },
    );
  }

  const DefaultLayout({
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 키보드 overflow 방지
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      // AppBar 뒤쪽에 화면 보일 수 있게 함.
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: bottomNavigationBar != null
          ? FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              child: Icon(Icons.favorite_border_outlined),
              onPressed: () {
                _showDialog(context);
                print("버튼 눌림");
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        title: Text(
          title!,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Pacifico', fontSize: 30, color: Colors.white),
        ),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        elevation: 0,
        // backgroundColor: Colors.transparent,
      );
    }
  }
}
