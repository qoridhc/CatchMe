import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/colors.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  @override
  Widget build(BuildContext context) {
    final _sw = MediaQuery.of(context).size.width;
    final _sh = MediaQuery.of(context).size.height;

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

    // 선택된 페이지의 인덱스 넘버 초기화
    int _selectedIndex = 0;

    List<Widget> _widgetOptions = [
      //  SendFavoritePage(),     //보낸 favorite body
      //  ReceiverFavoritePage()  //받은 favorite body
    ];

    void OnTappedBody(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    final PageController pageController = PageController(
      initialPage: 0,
    );


    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      key: _scaffoldKey,

      body: Column(
        children: [
          SizedBox(
            height: _sw * 0.001,
          ),
          Container(
            color: Colors.red,
            width:  _sw,
            height: _sw * 0.1,

            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.green,
                    width: _sw * 0.2,
                    height: _sw * 0.08,
                    //버튼
                  ),
                  // SizedBox(
                  //   height: _sw * 0.0001,
                  // ),
                  Container(
                    color: Colors.blue,
                    width: _sw * 0.2,
                    height: _sw * 0.08,
                    //버튼
                  ),
                ],
              ),
            )
          ),
          SizedBox(
            height: _sw * 0.001,
          ),
          Container(
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              children: [
                SizedBox.expand(
                  child: Container(
                    color: Colors.pink,
                  ),
                ),
                SizedBox.expand(
                  child: Container(
                    color: Colors.yellow,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
