import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/exception/DuplicateUserEvaluateException.dart';
import 'package:captone4/provider/follow_provider.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Token.dart';
import '../const/colors.dart';
import '../model/member_model.dart';
import 'package:dio/dio.dart';
import '../const/data.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';

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
  double _rating = 3;

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
            return _renderMemberList(snapshot.data!.memberList[0], userLength);
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
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => _renderEvaluationDialog(l.memberId));
      },
      child: Dismissible(
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
                        : Container(
                            width: getMediaWidth(context),
                            height: getMediaHeight(context) * 0.6,
                            child: CachedNetworkImage(
                              imageUrl: l.imageUrls[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Container(
                            // color: Colors.blue,
                            width: screenWidth / 3,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              l.nickname.length > 5
                                  ? l.nickname.substring(0, 6)
                                  : l.nickname,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.black,
                            width: screenWidth / 3,
                            child: Text(
                              userAge as String,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            // padding: EdgeInsets.on/ly(right: 15),
                            width: screenWidth / 4,
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
        // : emptyScreen(),
      ),
    );
  }

  // 얼굴 평가시 Dialog 띄워주기
  _renderEvaluationDialog(String targetId) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: getMediaHeight(context) * 0.25,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(height: 15),
            Container(
              child: Text(
                "얼굴 점수 평가",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // SizedBox(height: 10),
            Text("현재 유저의 얼굴점수를 평가해주세요!"),
            Container(
              width: MediaQuery.of(context).size.width,
              // height: getMediaHeight(context) * 0.07,
              child: Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: PRIMARY_COLOR,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = rating;
                  },
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        print("_rating = $_rating");
                        try {
                          final resp = await postRatingScore(targetId, _rating);

                          Navigator.pop(context);

                          showDialog(
                            context: context,
                            builder: (context) => _renderDefaultDialog([
                              "성공적으로 유저의 점수를",
                              "평가 완료 하였습니다.",
                            ]),
                            //"이미 얼굴을 평가한 유저는\n재평가 할 수 없습니다."
                          );
                        } on DuplicateUserEvaluateException catch (e) {
                          // 두번 이상 같은 유저를 평가하려고 하는 경우
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => _renderDefaultDialog(
                                ['이미 얼굴을 평가한 유저는', '재평가 할 수 없습니다.']),
                            //"이미 얼굴을 평가한 유저는\n재평가 할 수 없습니다."
                          );
                        }
                      },
                      child: Text(
                        "완료",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "취소",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 알림 Dialog 띄워주기
  _renderDefaultDialog(List<String> contents) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: getMediaHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // color: Colors.red,
                child: Text(
                  "알림",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: getMediaHeight(context) * 0.02),
          ...contents.map(
            (e) => Text(e),
          ),
          Container(
            width: getMediaWidth(context),
            height: getMediaHeight(context) * 0.07,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "확인",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 얼굴 점수 post 요청
  dynamic postRatingScore(String targetId, double score) async {
    print("getReceivedLike 실행");
    final dio = Dio();

    print("postRatingScore - score : $score");

    try {
      final resp = await dio.post(
        'http://$ip/api/v1/members/$targetId/score',
        data: {'score': score},
        options: Options(
          headers: {'authorization': 'Bearer ${widget.token!.accessToken}'},
        ),
      );

      print(resp);
      // state.last = LikeListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e.response?.statusCode);
      if (e.response?.statusCode == 403) {
        print("403에러발생");
        throw DuplicateUserEvaluateException();
      }
    }
  }
}
