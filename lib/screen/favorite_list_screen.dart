import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_network/image_network.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../const/data.dart';
import '../Token.dart';
import '../model/like_list_model.dart';
import '../model/member_model.dart';
import '../const/colors.dart';
import '../utils/utils.dart';
import '../widget/default_layout.dart';

class FavoriteListScreen extends StatefulWidget {
  final Token? token;
  const FavoriteListScreen({Key? key, @required this.token}) : super(key: key);

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  int _pageChanged = 0;     //page view index state
  bool _sendOrReceived = true;    //page view Send or Received bool

  late int _memberId;
  late String _memberToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _memberId = widget.token!.id!;
    _memberToken = widget.token!.accessToken!;
    print(_memberId);
    print(_memberToken);
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
      title: 'Favorite',
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
                          child: Center(child: Text('Received')),
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
                      if(_pageChanged == 0) _sendOrReceived = true;
                      else _sendOrReceived = false;
                    });
                  },
                  children: [
                    sendListviewBuilder(),
                    receivedListviewBuilder()
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

  //사용자가 보낸 like
  Future<LikeListModel> getSendLike() async {
    print("getSendLike 실행");
    final dio = Dio();
    final List<String> ls;

    try{
      final resp = await dio.get(
        CATCHME_URL + '/api/v1/classifications?memberId=${_memberId}&status=true',
        options: Options(
          headers: {
            'authorization': 'Bearer ${_memberToken}' // 없을 겨우 noAuth or NULL
          },
        ),
      );
      return LikeListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e);
      rethrow;
    }
  }

  //사용자 받은 like
  Future<LikeListModel> getReceivedLike() async {
    print("getReceivedLike 실행");
    final dio = Dio();

    try{
      final resp = await dio.get(
        CATCHME_URL + '/api/v1/classifications?targetId=${_memberId}&status=true',

        options: Options(
          headers: {
            'authorization': 'Bearer ${_memberToken}'
          },
        ),
      );
      return LikeListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e);
      rethrow;
    }
  }

  Widget sendListviewBuilder() {
    return Container(
        child: FutureBuilder<LikeListModel>(
            future: getSendLike(),
            builder: (_, AsyncSnapshot<LikeListModel> snapshot) {
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
                return ListView.builder(
                    itemCount: snapshot.data!.likeList.length,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    itemBuilder: (context, index) {
                      return _renderSendListView(snapshot.data!.likeList[index]);
                    });
              }
              else {
                return Center(child: Container(child: Text('Like를 보낸 정보가 없습니다.'),));
              }
            }
        )
    );
  }

  Widget _renderSendListView(LikeModel l){
    double _sw = getMediaWidth(context);
    double _sh = getMediaHeight(context);

    return Column(
      children: [
        Container(
        width:  _sw * 0.94,
        height: _sw * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black38),
        ),
        child: Row(
          children: [
            SizedBox(width: _sw * 0.015,),
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
               child: Container(
                 height: _sw * 0.15,
                 width: _sw * 0.15,
                  child: l.imgUrls.length > 0 ? Image.network(
                    l.imgUrls[l.imgUrls.length - 1],
                    fit: BoxFit.fill,
                  ):
                      Center(child: Text("NoImg")),
               ),
             ),
             SizedBox(
               width: _sw * 0.15,
             ),
             Container(
               child:Text(
                   l.nickname.length >= 7 ? l.nickname.substring(0, 7) + "..."+ '님에게 하트를 보냈습니다.' : l.nickname + '님에게 하트를 보냈습니다.',
               ),
              ),
            ],
          )
        ),
         Container(height: _sw*0.03,)
      ],
    );
  }

  Widget receivedListviewBuilder() {
    return Container(
        child: FutureBuilder<LikeListModel>(
            future: getReceivedLike(),
            builder: (_, AsyncSnapshot<LikeListModel> snapshot) {
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
                print(snapshot.data);
                return ListView.builder(
                    itemCount: snapshot.data!.likeList.length,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    itemBuilder: (context, index) {
                      return _renderReceivedListView(snapshot.data!.likeList[index]);
                    });
              }
              else {
                return Center(child: Container(child: Text('Like를 받은 정보가 없습니다.'),));
              }
            }
        )
    );
  }

  Widget _renderReceivedListView(LikeModel l){
    double _sw = getMediaWidth(context);
    double _sh = getMediaHeight(context);

    return Column(
      children: [
        Container(
            width:  _sw * 0.94,
            height: _sw * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black38),
            ),
            child: Row(
              children: [
                SizedBox(width: _sw * 0.015,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: _sw * 0.15,
                    width: _sw * 0.15,
                    child: l.imgUrls.length > 0 ? Image.network(
                      l.imgUrls[0],
                      fit: BoxFit.fill,
                    ):
                    Center(child: Text("NoImg")),
                  ),
                ),
                SizedBox(
                  width: _sw * 0.15,
                ),
                Container(
                  child: Text(
                      l.nickname + '님에게 하트를 받았습니다.'
                  ),
                ),
              ],
            )
        ),
        Container(height: _sw*0.03,)
      ],
    );
  }
}
