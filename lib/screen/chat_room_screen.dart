import 'dart:ui';
import 'package:captone4/screen/chatting_screen.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../widget/default_layout.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  int _pageChanged = 0;

  bool _chatsOrGroups = true;

  @override
  Widget build(BuildContext context) {
    final _sw = MediaQuery.of(context).size.width;
    final _sh = MediaQuery.of(context).size.height;

    final PageController _pageController = PageController(
      initialPage: 0,
    );

    return DefaultLayout(
      // backgroundColor: BACKGROUND_COLOR,
      title: 'Chat',
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: _sh * 0.005,
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
                              _chatsOrGroups = true;
                            });
                          },
                          child: Container(
                            width: _sw * 0.39,
                            height: _sw * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _chatsOrGroups ? Colors.white : Colors.transparent,
                            ),
                            child: Center(child: Text('chats')),
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
                              _chatsOrGroups = false;
                            });
                          },
                          child: Container(
                            width: _sw * 0.39,
                            height: _sw * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _chatsOrGroups ? Colors.transparent : Colors.white,
                            ),
                            child: Center(child: Text('Groups')),
                            //버튼
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
            SizedBox(
              height: _sw * 0.01,
            ),
            Expanded(
              child: Container(
                width: _sw,
                height: _sh,
                child: PageView(
                  pageSnapping: true,
                  controller: _pageController,
                  onPageChanged: (index){
                    setState(() {
                      _pageChanged = index;
                      print(_pageChanged);
                      if(_pageChanged == 0) _chatsOrGroups = true;
                      else _chatsOrGroups = false;
                    });
                  },
                  children: [
                    chatsListviewBuilder(),
                    GroupsListviewBuilder()
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _sw * 0.02,
            )
            //listview_builder(_index),
          ],
        ),
      ),
    );
  }
  Widget chatsListviewBuilder(){
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    final List<String> _img = <String>[
      'assets/images/test_img/1.jpg',
      'assets/images/test_img/2.jpg',
      'assets/images/test_img/3.jpg',
    ];
    final List<String> _name = <String>[
      '아이유',
      '차은우',
      '배수지',
    ];

    return ListView.builder(
      // scrollDirection: Axis.vertical,
      itemCount: _img.length,
      padding: EdgeInsets.symmetric(vertical: 0),
      itemBuilder: (BuildContext context, int index){
        return Container(
          width: double.infinity,
          height: 62*fem,
          padding: EdgeInsets.fromLTRB(40*fem, 0*fem, 0*fem, 0*fem),
          margin: EdgeInsets.fromLTRB(0,10,0,10),
          decoration: BoxDecoration (
            borderRadius: BorderRadius.circular(31*fem),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // image40kgV (1:81)
                width: 62.49*fem,
                height: 62*fem,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(31*fem),
                  child: Image.asset(
                    _img[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10*fem, 6*fem, 3*fem, 6*fem),
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupyuqsm5o (6J36NpyWkaQoJqNmfxYUqs)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 80*fem, 0*fem),
                      width: 80*fem,
                      height: 42*fem,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                          context,MaterialPageRoute(builder: (context)=>const ChatScreen()),
                        );},
                        child: Stack(
                          children: [
                            Positioned(
                              // message5MP (9:155)
                              left: 5*fem,
                              top: 20*fem,
                              child: Align(
                                child: SizedBox(
                                  width: 77*fem,
                                  height: 22*fem,
                                  child: Text(
                                    'message',
                                    style: SafeGoogleFont (
                                      'Inter',
                                      fontSize: 18*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2222222222*ffem/fem,
                                      color: Color(0xff808080),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // Adj (9:156)
                              left: 5*fem,
                              top: 0*fem,
                              child: Align(
                                child: SizedBox(
                                  width: 60*fem,
                                  height: 25*fem,
                                  child: Text(
                                    _name[index],
                                    style: SafeGoogleFont (
                                      'Estonia',
                                      fontSize: 20*ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.24*ffem/fem,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      // 2vq (9:157)
                      '12:00',
                      style: SafeGoogleFont (
                        'Estonia',
                        fontSize: 20*ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.24*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget GroupsListviewBuilder(){
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    final List<String> _img = <String>[
      'assets/images/test_img/1.jpg',
      'assets/images/test_img/2.jpg',
      'assets/images/test_img/3.jpg',
    ];
    final List<String> _name = <String>[
      '아이유',
      '차은우',
      '배수지',
    ];

    return ListView.builder(
      // scrollDirection: Axis.vertical,
      itemCount: _img.length,
      padding: EdgeInsets.symmetric(vertical: 0),
      itemBuilder: (BuildContext context, int index){
        return Container(
          width: double.infinity,
          height: 62*fem,
          padding: EdgeInsets.fromLTRB(40*fem, 0*fem, 0*fem, 0*fem),
          margin: EdgeInsets.fromLTRB(0,10,0,10),
          decoration: BoxDecoration (
            borderRadius: BorderRadius.circular(31*fem),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // image40kgV (1:81)
                width: 62.49*fem,
                height: 62*fem,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(31*fem),
                  child: Image.asset(
                    _img[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10*fem, 6*fem, 3*fem, 6*fem),
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupyuqsm5o (6J36NpyWkaQoJqNmfxYUqs)
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 80*fem, 0*fem),
                      width: 80*fem,
                      height: 42*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // message5MP (9:155)
                            left: 5*fem,
                            top: 20*fem,
                            child: Align(
                              child: SizedBox(
                                width: 77*fem,
                                height: 22*fem,
                                child: Text(
                                  'message',
                                  style: SafeGoogleFont (
                                    'Inter',
                                    fontSize: 18*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2222222222*ffem/fem,
                                    color: Color(0xff808080),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // Adj (9:156)
                            left: 5*fem,
                            top: 0*fem,
                            child: Align(
                              child: SizedBox(
                                width: 60*fem,
                                height: 25*fem,
                                child: Text(
                                  _name[index],
                                  style: SafeGoogleFont (
                                    'Estonia',
                                    fontSize: 20*ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.24*ffem/fem,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      // 2vq (9:157)
                      '12:00',
                      style: SafeGoogleFont (
                        'Estonia',
                        fontSize: 20*ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.24*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
