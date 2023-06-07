import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/const/colors.dart';
import 'package:captone4/model/member_model.dart';
import 'package:captone4/provider/follow_provider.dart';
import 'package:captone4/provider/member_profile_provider.dart';
import 'package:captone4/provider/member_provider.dart';
import 'package:captone4/screen/my_page/faq_screen.dart';
import 'package:captone4/screen/my_page/information_screen.dart';
import 'package:captone4/screen/my_page/profile_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Token.dart';
import '../../model/like_list_model.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  final Token token;

  const MyPageScreen({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  late int memberId;
  late String accessToken;
  late MemberModel tmpMember;

  Offset? offset;

  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    print("===== 마이페이지 init =====");
    memberId = widget.token.id!;
    accessToken = widget.token.accessToken!;

    ref.read(memberProfileNotifierProvider.notifier).getProfileImage();
    ref.read(memberNotifierProvider.notifier).getMemberInfoFromServer();
    ref.read(followNotifierProvider.notifier).getSendLike();
    ref.read(followNotifierProvider.notifier).getReceivedLike();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberProfileNotifierProvider);
    final memberState = ref.watch(memberNotifierProvider);
    final followState = ref.watch(followNotifierProvider);

    print(followState.last.count);

    return DefaultLayout(
      backgroundColor: const Color(0xFFFAFAFA),
      title: "My Page",
      child: SafeArea(
        child: Container(
            padding: EdgeInsets.only(top: 20),
            // color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          state.images.isEmpty == true
                              ? _renderMemberInfoTop(
                                  "empty", memberState, followState)
                              : _renderMemberInfoTop(state.images.last.url,
                                  memberState, followState),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                            child: LinearPercentIndicator(
                              percent: memberState.averageScore / 100,
                              // trailing: Text("${memberState.averageScore}"),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: getMediaHeight(context) * 0.31,
                        left: getMediaWidth(context) *
                            (1 - 0.11) *
                            (memberState.averageScore / 100),
                        child: Container(
                          decoration: BoxDecoration(
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(20)),
                          width: getMediaWidth(context) * 0.07,
                          height: getMediaHeight(context) * 0.03,
                          child: Center(
                            child: Text(
                              memberState.averageScore.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        _generateCategoryIcon(
                          const Icon(Icons.settings),
                          "Settings",
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FAQScreen(),
                              ),
                            );
                          },
                          child: _generateCategoryIcon(
                            const Icon(Icons.question_mark),
                            "FAQ",
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(),
                              ),
                            );
                          },
                          child: _generateCategoryIcon(
                            const Icon(Icons.info_rounded),
                            "Information",
                          ),
                        ),
                        InkWell(
                          child: _generateCategoryIcon(
                            const Icon(Icons.logout),
                            "logout",
                          ),
                          onTap: () {
                            Navigator.pop(context, "logout");
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );

  }

  Widget _renderMemberInfoTop(
      String images, MemberModel member, List<LikeListModel> follow) {
    return SizedBox(
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
                      token: widget.token,
                    ),
                  ),
                );
              },
              child: images == "empty"
                  ? Container(
                      child: const Center(
                        child: Text("프로필 이미지를 선택해주세요"),
                      ),
                    )
                  : Container(
                      // color: Colors.black,
                      child: CachedNetworkImage(
                        imageUrl: images,
                        imageBuilder: (context, imageProvider) => Container(
                          width: getMediaWidth(context) * 0.35,
                          height: getMediaHeight(context) * 0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )),
          Column(
            children: [
              member.nickname != ""
                  ? Text(
                      member.nickname.length > 4
                          ? member.nickname.substring(0, 4)
                          : member.nickname,
                      textScaleFactor: 1.18,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : const Text(
                      "",
                      textScaleFactor: 1.0,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
              Text(
                member.email,
                textScaleFactor: 1.0,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _generateMemberInfoIcon(0, "Tickets"), // 추후 api 연동해서 수정
              _generateMemberInfoIcon(follow.first.count, "Followings"),
              _generateMemberInfoIcon(follow.last.count, "Followers"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _generateCategoryIcon(Icon icon, String categoryName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: getMediaHeight(context) * 0.08,
        width: getMediaWidth(context) * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    categoryName,
                    textScaleFactor: 1.15,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }

  Widget _generateMemberInfoIcon(int value, String key) {
    return Column(
      children: [
        Text(
          value.toString(),
          textScaleFactor: 1.2,
          // style: TextStyle(fontSize: 20),
        ),
        Text(
          key,
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Offset? _getOffset() {
    if (_globalKey.currentContext != null) {
      final RenderBox renderBox =
          _globalKey.currentContext!.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      return offset;
    }
  }
}
