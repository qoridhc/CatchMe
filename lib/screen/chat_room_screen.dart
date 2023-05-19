import 'dart:ui';
import 'package:captone4/screen/chatting_screen.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';


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
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        //width: double.infinity,
        child: Container(
          // chatroom115hX (1:2)
          //width: double.infinity,
          decoration: BoxDecoration (
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(0*fem, 4*fem),
                blurRadius: 2*fem,
              ),
            ],
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // autogroupiczbTrV (6J34tNTaCFpDSJB7RAiCZb)
                  width: 393*fem,
                  height: 157*fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // group1026Rb (1:14) // chats, Groups부분
                        left: 34*fem,
                        top: 100*fem,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5*fem, 4*fem, 48*fem, 0*fem),
                          width: 322*fem,
                          height: 40*fem,
                          decoration: BoxDecoration (
                            color: Color(0xfff6f5f8),
                            borderRadius: BorderRadius.circular(15*fem),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3f000000),
                                offset: Offset(0*fem, 4*fem),
                                blurRadius: 2*fem,
                              ),
                            ],
                          ),// chats에 동그라미 쳐져있는거
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Container(
                                  // autogroupzrpfYHb (6J358HE4atZDXF36b2zrPF)
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 60*fem, 0*fem),
                                  width: 128*fem,
                                  //height: double.infinity,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // rectangle374mj (1:16)
                                        left: 0*fem,
                                        top: 0*fem,
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.blur (
                                            sigmaX: 2*fem,
                                            sigmaY: 2*fem,
                                          ),
                                          child: Align(
                                            child: SizedBox(
                                              width: 128*fem,
                                              height: 41*fem,
                                              child: Container(
                                                decoration: BoxDecoration (
                                                  borderRadius: BorderRadius.circular(15*fem),
                                                  color: Color(0xffffffff),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x3f000000),
                                                      offset: Offset(0*fem, 4*fem),
                                                      blurRadius: 2*fem,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // chatsJAH (1:18)
                                        left: 26*fem,
                                        top: 0*fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 63*fem,
                                            height: 42*fem,
                                            child: Text(
                                              'Chats',
                                              style: SafeGoogleFont (
                                                'Mukta',
                                                fontSize: 25*ffem,
                                                fontWeight: FontWeight.w700,
                                                height: 1.6625*ffem/fem,
                                                color: Color(0xff555555),
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
                                // groupsBE5 (1:17)
                                'Groups',
                                style: SafeGoogleFont (
                                  'Mukta',
                                  fontSize: 25*ffem,
                                  fontWeight: FontWeight.w700,
                                  height: 1.6625*ffem/fem,
                                  color: Color(0xff555555),
                                ),
                              ),
                            ],
                          ),
                        ),  // chats, Groups 나와있는 곳
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(40*fem, 5*fem, 0*fem, 62*fem),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // group113Ru7 (9:159)
                        width: double.infinity,
                        height: 62*fem,
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
                                  'assets/images/test_img/1.jpg',
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
                                              width: 40*fem,
                                              height: 25*fem,
                                              child: Text(
                                                '이름',
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
                      ),
                      SizedBox(
                        height: 13*fem,
                      ),
                      Container(
                        // group114krq (9:160)
                        width: double.infinity,
                        height: 62*fem,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular(100*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // image39VZX (1:83)
                              width: 61.03*fem,
                              height: 62*fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100*fem),
                                child: Image.asset(
                                  'assets/images/test_img/2.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              // autogroup8z85cu3 (6J35ZMLd11jh7WZoTp8z85)
                              padding: EdgeInsets.fromLTRB(10*fem, 0*fem, 2.07*fem, 0*fem),
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // autogroupq3tj9e5 (6J35TwKyZBkKYg86TSq3Tj)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 80*fem, 0*fem),
                                    width: 80*fem,
                                    height: 42*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // messaget5s (9:151)
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
                                          left: 5*fem,
                                          top: 0*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 40*fem,
                                              height: 25*fem,
                                              child: Text(
                                                '이름',
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
                                    // 5RF (9:153)
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
                      ),
                      SizedBox(
                        height: 13*fem,
                      ),
                      Container(
                        // group115QiR (9:161)
                        width: double.infinity,
                        height: 62*fem,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular(31*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // image40KKb (1:88)
                              width: 61.03*fem,
                              height: 62*fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(31*fem),
                                child: Image.asset(
                                  'assets/images/test_img/1.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              // autogroupbbttDA5 (6J35tbHZZ1rPAsvfiWBBTT)
                              padding: EdgeInsets.fromLTRB(10*fem, 0*fem, 2.07*fem, 0*fem),
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // autogrouplrz5hqw (6J35oqvUNrnUMM3a6VLRz5)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 80*fem, 0*fem),
                                    width: 80*fem,
                                    height: 42*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // messageBm7 (9:147)
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
                                          // 1EM (9:148)
                                          left: 5*fem,
                                          top: 0*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 40*fem,
                                              height: 25*fem,
                                              child: Text(
                                                '이름',
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
                                    // cV3 (9:149)
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
                      ),
                      SizedBox(
                        height: 13*fem,
                      ),
                      Container(
                        // group112w1X (9:158)
                        width: double.infinity,
                        height: 62*fem,
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular(100*fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // image39EmK (1:90)
                              width: 61.03*fem,
                              height: 62*fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100*fem),
                                child: Image.asset(
                                  'assets/images/test_img/2.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              // autogroupychsXEd (6J36AkVJc3CpGyJxp4YcHs)
                              padding: EdgeInsets.fromLTRB(10*fem, 8*fem, 2.07*fem, 9*fem),
                              height: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // autogroupp4gmSMb (6J366FcoHFyxEgGLxgP4GM)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 80*fem, 0*fem),
                                    width: 80*fem,
                                    height: 42*fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // messagexaq (1:89)
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
                                          // Sku (1:86)
                                          left: 5*fem,
                                          top: 0*fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 40*fem,
                                              height: 25*fem,
                                              child: Text(
                                                '이름',
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
                                  Container(
                                    // hB3 (9:137)
                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                                    child: Text(
                                      '12:00',
                                      style: SafeGoogleFont (
                                        'Estonia',
                                        fontSize: 20*ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.24*ffem/fem,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),// 대화 리스트
              ],
            ),

        ),
      ),
    );
  }
}
