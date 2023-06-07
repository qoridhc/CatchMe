import 'dart:convert';
import 'dart:ui';
import 'package:captone4/model/GroupRoomListModel.dart';
import 'package:captone4/screen/group_chatting_screen.dart';
import 'package:captone4/screen/single_chatting_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Token.dart';
import '../const/data.dart';
import '../model/member_model.dart';
import '../model/single_room_model.dart';
import '../utils/utils.dart';
import '../widget/default_layout.dart';

import 'package:stomp_dart_client/parser.dart';
import 'package:stomp_dart_client/sock_js/sock_js_parser.dart';
import 'package:stomp_dart_client/sock_js/sock_js_utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_exception.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';
import 'package:stomp_dart_client/stomp_parser.dart';
import "package:dart_amqp/dart_amqp.dart";

class ChatRoomScreen extends StatefulWidget {
  final Token? token;
  const ChatRoomScreen({Key? key, @required this.token}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  int _pageChanged = 0;
  bool _chatsOrGroups = true;

  late Token _token;
  late int _memberId;
  late String _memberToken;
  late int _mid;
  //late WebSocketChannel channel;

  List<DateTime> roomCreateTimeList = [];
  List<int> roomSingleNumberList = [];
  List<int> roomMultiNumberList = [];

  @override
  void initState() {
    super.initState();
    //channel = IOWebSocketChannel.connect('ws://10.0.2.2:9081/chat');

    DateTime room0CreateTime = DateTime.now(); // 임시로 현재 시간을 채팅방0 생성 시간으로 설정
    roomCreateTimeList.add(room0CreateTime); // 시간 리스트에 저장

    _token = widget.token!;

    _memberId = widget.token!.id!;            // 로그인한 사람
    _memberToken = widget.token!.accessToken!;  // 여기 에러 왜?????????
    //channel = IOWebSocketChannel.connect('ws://10.0.2.2:9081/chat');
  }

  @override
  void dispose() {
   // channel.sink.close();
    super.dispose();
  }

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
          children: <Widget>[
            SizedBox(
              height: _sh * 0.005,
            ),
            Container(
                width: _sw,
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
                              color: _chatsOrGroups
                                  ? Colors.white
                                  : Colors.transparent,
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
                              color: _chatsOrGroups
                                  ? Colors.transparent
                                  : Colors.white,
                            ),
                            child: Center(child: Text('Groups')),
                            //버튼
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
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
                  onPageChanged: (index) {
                    setState(() {
                      _pageChanged = index;
                      print(_pageChanged);
                      if (_pageChanged == 0)
                        _chatsOrGroups = true;
                      else
                        _chatsOrGroups = false;
                    });
                  },
                  children: [chatsListviewBuilder(), _renderGroupListView()],
                ),
              ),
            ),
            SizedBox(
              height: _sw * 0.02,
            ),
            //listview_builder(_index),
          ],
        ),
      ),
    );
  }

  Future<MemberModel> getUserInfo(int mid) async {
    print("Get user's information");
    final dio = Dio();

    try {
      final getInfo = await dio.get(CATCHME_URL + '/api/v1/members/${mid}',
        options: Options(
          headers: {
            'authorization': 'Bearer ${_memberToken}'
          },
        ),
      ); // 여기에 mid1이나 mid2값을 넣는 방법은?
      return MemberModel.fromJson(json: getInfo.data);
    } on DioError catch (e) {
      print('error: $e');
      print(e);
      rethrow;
    }
  }

  //싱글 채팅방 리스트 호출
  Future<SingleRoomListModel> getSingleRoomList() async{
    print("getRoomList 실행");
    final dio = Dio();
    final List<String> ls;

    try{
      final response = await dio.get(CHATTING_API_URL + '/api/v1/single_room?mid=$_memberId');
      return SingleRoomListModel.fromJson(json: response.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e);
      rethrow;
    }
  }

  Widget chatsListviewBuilder() {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    final List<String> _img = <String>[];
    final List<String> _name = <String>[];

    return Container(
      child: FutureBuilder<SingleRoomListModel>(
        future: getSingleRoomList(),
        builder: (_, AsyncSnapshot<SingleRoomListModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString())
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.count != 0) {
            return ListView.builder(// container를 넣고 child를 넣고 그안에 futurebuilder 이건 재민이형 api 받을수있게
                itemCount: snapshot.data!.singleRoomList.length,
                padding: EdgeInsets.symmetric(vertical: 0),
                itemBuilder: (context, index) {
                  int _mid = snapshot.data!.singleRoomList[index].mid1 == _memberId
                      ? snapshot.data!.singleRoomList[index].mid2 :
                  snapshot.data!.singleRoomList[index].mid1;
                  roomSingleNumberList.add(snapshot.data!.singleRoomList[index].id);
                  return renderMemberLInfo(_mid, index); // 여기서 회원 정보 던져줘야 하는 상황
                });
          }
          else {
            return Center(child: Container(child: Text('생성된 채팅방이 없습니다'),));
          }
        },
      ),
    );
  }

  Widget renderMemberLInfo(int mid, int indexNum) {
    return Container(
      child: FutureBuilder<MemberModel>(
        future: getUserInfo(mid),
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
            return _renderSingleRoomListView(
                snapshot.data!, indexNum);
          } else {
            return Center(
              child: Text("해당 정보가 없습니다."),
            );
          }
        },
      ),
    );
  }

  Widget _renderSingleRoomListView(MemberModel l, int indexNum){ // 여기서 회원 정보를 받고 아래서 돌리기
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double _sw = getMediaWidth(context);

    return Container(
      width: double.infinity,
      height: 62 * fem,
      padding: EdgeInsets.fromLTRB(40 * fem, 0 * fem, 0 * fem, 0 * fem),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31 * fem),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // image40kgV (1:81)
            width: 62.49 * fem,
            height: 62 * fem,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(31 * fem),
              child: Container(
                height: _sw * 0.15,
                width: _sw * 0.15,
                child: l.imageUrls.length > 0 ? Image.network(  //memberinfo에서 imgurl가져오기
                  l.imageUrls[0],
                  fit: BoxFit.fill,
                ):
                Center(child: Text("NoImg")),
              ),
            ),
          ),
          Container(
            padding:
            EdgeInsets.fromLTRB(10 * fem, 6 * fem, 3 * fem, 6 * fem),
            height: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // autogroupyuqsm5o (6J36NpyWkaQoJqNmfxYUqs)
                  margin: EdgeInsets.fromLTRB(
                      0 * fem, 0 * fem, 80 * fem, 0 * fem),
                  width: 80 * fem,
                  height: 42 * fem,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleChattingScreen(
                            roomNum: roomSingleNumberList[indexNum],
                            token: _token,
                            // 0번째 채팅방 생성시간
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          // Adj (9:156)
                          left: 5 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 60 * fem,
                              height: 25 * fem,
                              child: Text(
                                l.nickname,  // 이부분은 id에 해당하는 이름으로 바꿔줘야함
                                style: SafeGoogleFont(
                                  'Estonia',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.24 * ffem / fem,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  //그룹 채팅방 리스트 호출
  Future<GroupRoomListModel> getGroupRoomList() async{
    print("getRoomList 실행");
    final dio = Dio();
    final List<String> ls;

    try{
      final response = await dio.get('http://localhost:9081/api/v1/group_room?mid=$_memberId');
      return GroupRoomListModel.fromJson(json: response.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e);
      rethrow;
    }
  }

  Widget _renderGroupListView() {
    return Container(
      child: FutureBuilder<GroupRoomListModel>(
        future: getGroupRoomList(),
          builder: (_, AsyncSnapshot<GroupRoomListModel> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              }
              if (snapshot.data!.count != 0) {
                return ListView.builder(
                    itemCount: snapshot.data!.groupRoomList.length,
                    padding: EdgeInsets.symmetric(vertical: 0),
                  itemBuilder: (context, index){
                     return _renderGroupListChild(snapshot.data!.groupRoomList[index], index);
                  });
              }
              else{
                return Center(child: Container(child: Text('생성된 그룹 채팅방이 없습니다.')));
              }
          }
      )
    );
  }

  Widget _renderGroupListChild(GroupRoomModel m, int i){
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return InkWell(
      onTap: (){
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChattingScreen(
            roomData: m,
            token: _token
            // 0번째 채팅방 생성시간
          ),
        ),
      );},
      child: Container(
          width: double.infinity,
          height: 62 * fem,
          child: Text("그룹채팅 $i"),
      ),
    );

  }

  /*
  Widget GroupsListviewBuilder() {
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
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          height: 62 * fem,
          padding: EdgeInsets.fromLTRB(40 * fem, 0 * fem, 0 * fem, 0 * fem),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(31 * fem),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // image40kgV (1:81)
                width: 62.49 * fem,
                height: 62 * fem,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(31 * fem),
                  child: Image.asset(
                    _img[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.fromLTRB(10 * fem, 6 * fem, 3 * fem, 6 * fem),
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupyuqsm5o (6J36NpyWkaQoJqNmfxYUqs)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 80 * fem, 0 * fem),
                      width: 80 * fem,
                      height: 42 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // message5MP (9:155)
                            left: 5 * fem,
                            top: 20 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 77 * fem,
                                height: 22 * fem,
                                child: Text(
                                  'message',
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 18 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2222222222 * ffem / fem,
                                    color: Color(0xff808080),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // Adj (9:156)
                            left: 5 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 60 * fem,
                                height: 25 * fem,
                                child: Text(
                                  _name[index],
                                  style: SafeGoogleFont(
                                    'Estonia',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.24 * ffem / fem,
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
                      style: SafeGoogleFont(
                        'Estonia',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.24 * fem / fem,
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

   */
}
