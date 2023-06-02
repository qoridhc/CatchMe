import 'dart:convert';

import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';
import '../Token.dart';
import '../model/member_model.dart';
import 'package:dio/dio.dart';
import '../const/data.dart';
import 'package:http/http.dart' as http;

class MainPageScreen extends StatefulWidget {
  final Token? token;
  const MainPageScreen({Key? key, @required this.token}) : super(key: key);

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  int currentIndex = 0;
  late int _memberId;
  late String _memberToken;
  late String userGender;
  // late String userGender;

  @override
  void initState() {
    super.initState();

    _memberId = widget.token!.id!;
    _memberToken = widget.token!.accessToken!;
    print(_memberId);
    print(_memberToken);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double availableHeight = screenHeight - appBarHeight;

    return DefaultLayout(
      title: "Main",
      child: Center(
        child: renderUserGenderBuild(),
      ),
      // child: Image.asset(users[currentIndex].imageUrls),
    );
  }

  //  사용자 성별 설정 
  Future<MemberModel> getUserGender() async {
    print("Get user's information");
    final dio = Dio();

    try {
      final getGender = await dio.get(
        'http://$ip/api/v1/members/${_memberId}',
        options: Options(
          headers: {'authorization': 'Bearer ${_memberToken}'},
        ),
      );
      return MemberModel.fromJson(json: getGender.data);
    } on DioError catch (e) {
      print('error');
      print(e);
      rethrow;
    }
  }
  // 사용자 성별 정보 얻고 반대 성별 설정
  Widget renderUserGenderBuild() {
    return Container(
      child: FutureBuilder<MemberModel>(
        future: getUserGender(),
        builder: (_, AsyncSnapshot<MemberModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data! != 0) {
            if (snapshot.data!.gender != 'F') {
              print(snapshot.data!.gender);
              userGender = 'M';
              return renderMemberListViewBuilder(userGender);
            } else {
              userGender = 'F';
              return renderMemberListViewBuilder(userGender);
            }
          } else {
            return const Center(
              child: Text("There's no such information."),
            );
          }
        },
      ),
    );
  }
  // 성별에 맞게 멤버 리스트 구하기
  Future<MemberListModel> getMemberList(String userGender) async {
    print("Get user's information");
    print(this.userGender);
    final dio = Dio();

    try {
      final resp = await dio.get(
        'http://$ip/api/v1/search?gender=${userGender}',
        options: Options(
          headers: {'authorization': 'Bearer ${_memberToken}'},
        ),
      );
      return MemberListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print('error');
      print(e);
      rethrow;
    }
  }
  // 멤버 리스트 가져오기
  Widget renderMemberListViewBuilder(String userGender) {
    return Container(
      child: FutureBuilder<MemberListModel>(
        future: getMemberList(userGender),
        builder: (_, AsyncSnapshot<MemberListModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.count != 0) {
            var userLength = snapshot.data!.count - 1;
            return _renderMemberList(
                snapshot.data!.memberList[currentIndex], userLength);
          } else {
            return Center(
              child: Text("해당 정보가 없습니다."),
            );
          }
        },
      ),
    );
  }

  // 하트 보내거나 거절하기
  Future<void> sendHeart(MemberModel l, String status) async {
    print("마음 보내기");
    final dio = Dio();
    var url = 'http://$ip/api/v1/classifications';

    try {
      Map data = {
        "memberId": _memberId,
        "targetId": l.memberId,
        "status": status
      };

      var body = json.encode(data);

      final resp = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': "Bearer $_memberToken"
        },
        body: body,
      );
      print('resp status code');
      print(resp.statusCode);
      if (resp.statusCode == 200) {
        if (status == 'false') {
          print('거절');
        } else {
          print('하트 보내기');
        }
      }
    } on DioError catch (e) {
      print('error');
      print(e);
      rethrow;
    }
  }

  Widget _renderMemberList(MemberModel l, int userLength) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int birthYear = int.parse(l.birthYear);
    String userAge = (2023 - birthYear).toString();
    late String status;
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      // 스와이프 할 때 효과
      background: Container(
        // 왼쪽으로 스와이프 = no
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: const [
              Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              Text(
                '  Nope',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ],
          ),
        ),
      ),
      // 오른쪽으로 스와이프 = yes
      secondaryBackground: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.favorite, color: Colors.white, size: 30),
              Text('  Like',
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(
            () {
              if (currentIndex < userLength) {
                currentIndex += 1;
                print("오른쪽");
                status = 'true';
                sendHeart(l, status);
              } else if (currentIndex >= userLength) {
                currentIndex = 0;
              }
            },
          );
        } else if (direction == DismissDirection.startToEnd) {
          setState(
            () {
              if (currentIndex < userLength) {
                currentIndex += 1;
                print("왼쪽");
                status = 'false';
                sendHeart(l, status);
              } else if (currentIndex >= userLength) {
                currentIndex = 0;
              }
            },
          );
        }
      },
      child: Container(
        height: screenHeight,
        child: Card(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  // (l.imageUrls.isEmpty == true)
                  //     ? Container()
                  //     : Image.asset(
                  //         l.imageUrls.join(),
                  //         fit: BoxFit.cover,
                  //         alignment: Alignment.center,
                  //       ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth / 4,
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          l.nickname,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth / 3,
                        child: Text(
                          userAge as String,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        width: screenWidth / 3,
                        child: Text(
                          l.mbti,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  (l.introduction == null)
                      ? Container()
                      : Container(
                          width: screenWidth,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            l.introduction!,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
