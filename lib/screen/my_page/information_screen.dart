import 'package:flutter/material.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utils.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Information",
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  // color: Colors.black,
                  height: getMediaHeight(context) * 0.25,
                  width: getMediaWidth(context),
                  child: Image.asset(
                    'assets/images/image 45.png',
                  ),
                ),
              ),
              SizedBox(
                height: getMediaHeight(context) * 0.04,
              ),
              Center(
                child: Text(
                  "Catch Me가 무엇인가요?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: getMediaHeight(context) * 0.01,
              ),
              Center(
                child: Text(
                  "저희 Catch Me는 소개팅과 게임을 접목한",
                ),
              ),
              Center(
                child: Text(
                  "새로운 방식의 소개팅 앱입니다.",
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        "Developer",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _generateCategoryIcon("qoridhc", "https://github.com/qoridhc"),
              _generateCategoryIcon(
                  "realcold0", "https://github.com/realcold0"),
              _generateCategoryIcon(
                  "DonghyeonKwon", "https://github.com/DonghyeonKwon"),
              _generateCategoryIcon(
                  "ashmin-yoon", "https://github.com/ashmin-yoon"),
              _generateCategoryIcon("Daekyue", "https://github.com/Daekyue"),
              _generateCategoryIcon("J0a0J", "https://github.com/J0a0J"),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Divider(
                  thickness: 1.5,
                ),
              ),
              Container(
                child: Center(
                  child: Text("developed by"),
                ),
              ),
              Container(
                child: Center(
                  child: Text("계명대학교 컴퓨터 공학과 학생들"),
                ),
              ),
              SizedBox(height: getMediaHeight(context) * 0.02,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _generateCategoryIcon(String name, String gitUrl) {

    // print("assets/images/git_profile/${name+'_profile'}.png");

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: getMediaHeight(context) * 0.1,
          width: getMediaWidth(context) * 0.82,
          decoration: BoxDecoration(
            // color: Colors.grey,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                // color: Colors.grey
                ),
          ),
          child: Container(
            // color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(
                      width: getMediaWidth(context) * 0.12,
                      // height: getMediaHeight(context) * 0.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/git_profile/${name + '_profile'}.png'),
                        ),
                      ),
                    ),

                    // Container(
                    //   height: getMediaHeight(context) * 0.06,
                    //   width: getMediaWidth(context) * 0.12,
                    //   child: Image.asset(
                    //     'assets/images/git_profile/${name + '_profile'}.png',
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: Container(
                        // height: getMediaHeight(context) * 0.01,
                        // width: getMediaWidth(context) * 0.5,
                        // color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.white,
                              child: Text(
                                name,
                                textScaleFactor: 1.2,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                // color: Colors.blue,
                                child: Text(
                                  gitUrl,
                                  textScaleFactor: gitUrl.length < 30 ? 1.0 : 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
