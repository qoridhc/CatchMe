import 'package:captone4/const/colors.dart';
import 'package:captone4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: Text("Cath Me Default AppBar"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Container(
                // color: Colors.red,
                child: CircleAvatar(
                  radius: getMediaWidth(context) * 0.32,
                  backgroundImage: NetworkImage(
                    "https://image.ytn.co.kr/general/jpg/2022/0516/202205160929084105_d.jpg",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: LinearPercentIndicator(
                percent: 0.5,
              ),
            ),
            Flexible(
              child: Container(
                // color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                      child: Container(
                        child: Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < 5; i++)
                          _generateCategoryIcon(
                              "assets/images/icons/chat_icon.png"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < 5; i++)
                          _generateCategoryIcon(
                              "assets/images/icons/chat_icon.png"),
                        // _generateCategoryIcon(
                        //     "assets/images/icons/chat_icon.png"),
                        // _generateCategoryIcon(
                        //     "assets/images/icons/chat_icon.png"),
                        // _generateCategoryIcon(
                        //     "assets/images/icons/chat_icon.png"),
                        // _generateCategoryIcon(
                        //     "assets/images/icons/chat_icon.png"),
                        // _generateCategoryIcon(
                        //     "assets/images/icons/chat_icon.png"),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _generateCategoryIcon(String imgUrl) {
    return Column(
      children: [
        InkWell(
          onTap: () {
          },
          child: Container(
            // height: getMediaHeight(context) * 0.2,
            width: getMediaWidth(context) * 0.15,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imgUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text("data"),
      ],
    );
  }
}
