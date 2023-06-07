import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/provider/follow_provider.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Token.dart';
import '../model/member_model.dart';
import 'package:dio/dio.dart';
import '../const/data.dart';
import 'package:http/http.dart' as http;

class MainPageScreen extends ConsumerStatefulWidget {
  final Token? token;
  const MainPageScreen({Key? key, @required this.token}) : super(key: key);

  @override
  ConsumerState<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends ConsumerState<MainPageScreen> {
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
    );
  }

  //  사용자 성별 설정
  Future<MemberModel> getUserGender() async {
    print("Get user's information");
    final dio = Dio();

    try {
      final getGender = await dio.get(
        CATCHME_URL + '/api/v1/members/${_memberId}',
        options: Options(
          headers: {'authorization': 'Bearer ${_memberToken}'},
        ),
      );
      return MemberModel.fromJson(json: getGender.data);
    } on DioError catch (e) {
      print('error: $e');
      emptyScreen();
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
            if (snapshot.data!.gender == 'W') {
              //유저가 여자일때
              userGender = 'M'; //남자ㅏ를 보여주고
              print('Opposite userGender information $userGender');
              return renderMemberListViewBuilder(userGender);
            } else {
              //유저가 남자일때
              userGender = 'W'; //여자를 보여준다
              print('Opposite userGender information $userGender');
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
    print("Get user's information: $userGender");
    final dio = Dio();

    try {
      final resp = await dio.get(
        CATCHME_URL + '/api/v1/search?gender=${userGender}',
        options: Options(
          headers: {'authorization': 'Bearer ${_memberToken}'},
        ),
      );
      return MemberListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print('error: $e');
      emptyScreen();
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
            print('유저 목록 길이 $userLength');
            return _renderMemberList(
                snapshot.data!.memberList[0], userLength);
          } else {
            return Center(
              child: Text("해당 정보가 없습니다."),
            );
          }
        },
      ),
    );
  }

  // 분류하기
  Future<void> sendHeart(MemberModel l, String status) async {
    print("마음 보내기");
    final dio = Dio();
    var url = CATCHME_URL + '/api/v1/classifications';

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
      print('resp status code ${resp.statusCode}');
      if (resp.statusCode == 200) {
        if (status == 'false') {
          print('거절');
        } else {
          print('하트 보내기');
          ref.read(followNotifierProvider.notifier).getSendLike();
        }
      }
    } on DioError catch (e) {
      print('error $e');
      emptyScreen();
      rethrow;
    }
  }

  Widget emptyScreen() {
    return const Card(
      child: Center(
        child: Text(
          '더 이상 선택할 유저가 존재하지 않습니다.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
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
                if (userLength >= 0) {
                  status = 'true';
                  print('오른쪽으로 스와이프. 유저 이름 ${l.nickname}');
                  if (userLength == 0) {
                    sendHeart(l, status);
                  } else {
                    sendHeart(l, status);
                  }
                }
              },
            );
          } else if (direction == DismissDirection.startToEnd) {
            setState(
              () {
                print('왼쪽으로 스와이프. 유저 이름 ${l.nickname}');
                status = 'false';
                if (userLength >= 0) {
                  if (userLength == 0) {
                    sendHeart(l, status);
                  } else {
                    sendHeart(l, status);
                  }
                }
              },
            );
          }
        },
        child: Container(
          // ? Container(
          // child: Container(
          height: screenHeight,
          child: Card(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    (l.imageUrls.isEmpty == true)
                        ? Container()
                        // : Image.network(
                        //     l.imageUrls[0],
                        //     fit: BoxFit.cover,
                        //     alignment: Alignment.center,
                        //   ),
                        : CachedNetworkImage(imageUrl: l.imageUrls[0]),
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
        )
        // : emptyScreen(),
        );
  }
}