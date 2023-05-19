import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/const/data.dart';
import 'package:captone4/model/member_model.dart';
import 'package:captone4/screen/profile_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../model/member_profile_model.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final tmpMemberId = '1';
  final tmpAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJtZW1iZXJJZCI6MSwiaWF0IjoxNjg0NDg4NDkyLCJleHAiOjE2ODQ0OTIwOTJ9.gEwlaPzeRo4DrYpiQ9E_DHFctTbfLcZaOehD7QaHpUA';

  late MemberModel tmpMember;
  late final profileImage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMemberInfoFromServer();
      // _getProfileImageFromServer();
    });
  }

  _getMemberInfoFromServer() async {
    print("_getMemberInfoFromServer 실행");
    final dio = Dio();

    try {
      final resp = await dio.get(
        'http://$ip/api/v1/members/1',
        options: Options(
          headers: {
            'authorization': 'Bearer $tmpAccessToken',
          },
        ),
      );

      return resp.data;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<MemberProfileModel> _getProfileImageFromServer() async {
    print("_getProfileImageFromServer 실행");
    final dio = Dio();

    try {
      final resp = await dio.get(
        'http://$ip/api/v1/members/$tmpMemberId/images',
        options: Options(
          headers: {
            'authorization': 'Bearer $tmpAccessToken',
          },
        ),
      );

      return MemberProfileModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print("에러발생");
      print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Color(0xFFFAFAFA),
      title: "My Page",
      child: Padding(
        padding: EdgeInsets.only(top: getAppBarHeight(context) * 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<MemberProfileModel>(
                future: _getProfileImageFromServer(),
                builder: (_, AsyncSnapshot<MemberProfileModel> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // var mpi = snapshot.data!.images.last;
                  //  print("mpi.url : " + mpi.url);
                  // if(snapshot.data!.count != 0)
                  //   print(snapshot.data!.images[snapshot.data!.count]);
                  if (snapshot.data!.count == 0)
                    return _renderMemberInfoTop("empty");
                  else
                    return _renderMemberInfoTop("https://s3.orbi.kr/data/file/united2/0fec8ab35d294043bc1d611487c91d20.jpeg");
                }
                // https://s3.orbi.kr/data/file/united2/0fec8ab35d294043bc1d611487c91d20.jpeg
                // child: _renderMemberInfoTop()
                ),
            // _renderMemberInfoTop(
            //     "https://img.hankyung.com/photo/202205/BF.29986262.1.jpg"),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: LinearPercentIndicator(
                percent: 0.5,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _generateCategoryIcon(
                      Icon(Icons.settings),
                      "settings",
                    ),
                    _generateCategoryIcon(
                      Icon(Icons.settings),
                      "settings",
                    ),
                    _generateCategoryIcon(
                      Icon(Icons.settings),
                      "settings",
                    ),
                    _generateCategoryIcon(
                      Icon(Icons.settings),
                      "settings",
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderMemberInfoTop(String images) {
    return Container(
      // color: Colors.black,
      height: getMediaHeight(context) * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    tmpMemberId: tmpMemberId,
                    tmpAccessToken: tmpAccessToken,
                  ),
                ),
              );
            },
            child: images == "empty"
                ? Container(
                    child: Center(
                      child: Text("프로필 이미지를 선택해주세요"),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(180),
                    child:
                    // Image.file("C:\Users\LSH\Desktop\images.jfif")
                    
                    ImageNetwork(
                      image: images,
                      height: getMediaHeight(context) * 0.15,
                      width: getMediaWidth(context) * 0.3,
                      debugPrint: true,
                      onError: const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      onTap: () {
                        debugPrint("©gabriel_patrick_souza");
                      },
                    ),

                    // CachedNetworkImage(
                    //   imageUrl: "https://picsum.photos/250?image=9",
                    //   placeholder: (context, url) => CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    //   fit: BoxFit.fill,
                    //   height: getMediaHeight(context) * 0.15,
                    //   width: getMediaWidth(context) * 0.3,
                    // ),
                  ),
          ),
          Column(
            children: [
              Text("Kim MinJu",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              Text(
                "@izone",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
          Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _generateMemberInfoIcon(3, "Tickets"),
            _generateMemberInfoIcon(23, "Followings"),
            _generateMemberInfoIcon(3, "Followers"),
          ]),
        ],
      ),
    );
  }

  Widget _generateCategoryIcon(Icon icon, String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.black,
              width: getMediaWidth(context) * 0.32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: getMediaHeight(context) * 0.06,
                    width: getMediaWidth(context) * 0.12,
                    child: icon,
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    categoryName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right)
          ],
        ),
        height: getMediaHeight(context) * 0.08,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), border: Border.all()),
      ),
    );
  }

  Widget _generateMemberInfoIcon(int value, String key) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 20),
        ),
        Text(
          key,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  void _postImage() async {
    final dio = Dio();
    //
    // final resp = await dio.post(
    //   'http://$ip/api/v1/members/$tmpMemberId/?images=https://img.hankyung.com/photo/202005/BF.22650697.1.jpg',
    //   options: Options(
    //     headers: {
    //       'authorization': 'Bearer $tmpAccessToken',
    //     },
    //   ),
    // );
  }
}
