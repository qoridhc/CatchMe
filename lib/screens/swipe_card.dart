import '../models/custom_appbar.dart';
import '../models/custom_text_painter.dart';
import '../models/detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';


class SwipeCard extends StatelessWidget {
  final String imgUrl;
  final String userName;
  final int userAge;
  final String? userMbti;
  final String? userStatus;
  final String userInfo;
  final Color backColor;
  const SwipeCard({
    Key? key,
    required this.imgUrl,
    required this.userName,
    required this.userAge,
    required this.userInfo,
    required this.backColor,
    this.userMbti,
    this.userStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double availableHeight = screenHeight - appBarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          fontColor: Color(0xFFFF6961),
          appBarColor: Colors.transparent,
          // appBarColor: Colors.blue,
          appBarTitle: 'Catch me',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: (screenWidth / 8) * 7,
            height: (availableHeight / 7) * 6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: const Offset(5, 5),
                ),
                const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 15,
                        spreadRadius: 1)
                    .scale(2),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                ],
              ),
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                // 사진 확대
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(imgUrl: imgUrl),
                      ),
                    );
                  },
                  // 사진 첨부
                  // 사진 첨부
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Hero(
                        tag: imgUrl,
                        child: Container(
                          child: Image.asset(
                            imgUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 개인정보
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // 이름 나이
                      Row(
                        children: [
                          Text(
                            '$userName',
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                              fontFamily: 'NanumGothic',
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$userAge',
                            style: const TextStyle(fontSize: 38),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // 성격 특성 나타내는 부분
                      Row(
                        children: [
                          CustomTextPainter(text: '$userMbti'),
                          userStatus == null
                              ? const SizedBox(width: 0)
                              : Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    CustomTextPainter(
                                      text: '$userStatus',
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text('$userInfo', textAlign: TextAlign.start,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
