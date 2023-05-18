import 'package:flutter/material.dart';
import '../const/colors.dart';

import '../widget/default_layout.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  int _pageChanged = 0;

  bool _sendOrReceived = true;

  @override
  Widget build(BuildContext context) {

    final _sw = MediaQuery.of(context).size.width;
    final _sh = MediaQuery.of(context).size.height;


    final PageController _pageController = PageController(
      initialPage: 0,
    );

    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Column(
        children: [
          SizedBox(
            height: _sw * 0.001,
          ),
          Container(
            width:  _sw,
            height: _sw * 0.1,
            child: Center(
              child: Container(
                width: _sw * 0.8,
                height: _sw * 0.09,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black38,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.linear);
                        setState(() {
                          _sendOrReceived = true;
                        });
                      },
                      child: Container(
                        width: _sw * 0.39,
                        height: _sw * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _sendOrReceived ? Colors.white : Colors.transparent,
                        ),
                        child: Center(child: Text('Send')),
                        //버튼
                      ),
                    ),
                    SizedBox(
                      width: _sw * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.linear);
                        setState(() {
                          _sendOrReceived = false;
                        });
                      },
                      child: Container(
                        width: _sw * 0.39,
                        height: _sw * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _sendOrReceived ? Colors.transparent : Colors.white,
                        ),
                        child: Center(child: Text('Recieved')),
                        //버튼
                      ),
                    ),
                    // Container(
                    //   width: _sw * 0.39,
                    //   height: _sw * 0.08,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: InkWell(
                    //     onTap: () {
                    //       _pageController.animateToPage(0,
                    //           duration: Duration(milliseconds: 250),
                    //           curve: Curves.linear);
                    //     },
                    //     child: Center(child: Text('Send')),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: _sw * 0.01,
                    // ),
                    // Container(
                    //   width: _sw * 0.39,
                    //   height: _sw * 0.08,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: InkWell(
                    //     onTap: () {
                    //       _pageController.animateToPage(1,
                    //           duration: Duration(milliseconds: 250),
                    //           curve: Curves.linear);
                    //     },
                    //     borderRadius: BorderRadius.circular(15),
                    //     focusColor: Colors.white,
                    //     child: Center(child: Text('Received')),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ),
          SizedBox(
            height: _sw * 0.01,
          ),
          Container(
            width: _sw,
            height: _sh * 0.75,
            child: PageView(
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (index){
                setState(() {
                  _pageChanged = index;
                  print(_pageChanged);
                  if(_pageChanged == 0) _sendOrReceived = true;
                  else _sendOrReceived = false;
                });
              },
              children: [
                sendListviewBuilder(),
                receivedListviewBuilder()
              ],
            ),
          )
          //listview_builder(_index),
        ],
      ),
    );
  }

  Widget sendListviewBuilder(){

    final _sw = MediaQuery.of(context).size.width;
    final _sh = MediaQuery.of(context).size.height;

    final List<String> _img = <String>[
      'assets/images/test_img/1.jpg',
      'assets/images/test_img/2.jpg',
      'assets/images/test_img/3.jpg',
    ];

    final List<String> _name = <String>[
      '아이유',
      '차은우',
      '배수지'
    ];

    return Container(
      width: _sw,
      height: _sh * 0.75,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _img.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            height: _sw * 0.2,
            child: Row(
              children: [
                Container(
                  height: _sw * 0.15,
                  width: _sw * 0.15,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(_img[index]))
                  ),
                ),
                SizedBox(
                  width: _sw * 0.15,
                ),
                Container(
                  child: Text(
                    _name[index] + '님에게 하트를 보냈습니다.'
                  ),
                ),
              ],
            )
          );
        },


      ),
    );
  }

  Widget receivedListviewBuilder(){

    final _sw = MediaQuery.of(context).size.width;
    final _sh = MediaQuery.of(context).size.height;

    final List<String> _img = <String>[
      'assets/images/test_img/1.jpg',
      'assets/images/test_img/2.jpg',
      'assets/images/test_img/3.jpg',
    ];

    final List<String> _name = <String>[
      '아이유',
      '차은우',
      '배수지'
    ];
    return Container(
      width: _sw,
      height: _sh * 0.75,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _img.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
              height: _sw * 0.2,
              child: Row(
                children: [
                  Container(
                    height: _sw * 0.15,
                    width: _sw * 0.15,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(_img[index]))
                    ),
                  ),
                  SizedBox(
                    width: _sw * 0.15,
                  ),
                  Container(
                    child: Text(
                        _name[index] + '님에게 하트를 받았습니다.'
                    ),
                  ),
                ],
              )
          );
        },
      ),
    );
  }
}
