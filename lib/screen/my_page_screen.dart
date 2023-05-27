import 'package:captone4/const/colors.dart';
import 'package:captone4/model/member_model.dart';
import 'package:captone4/provider/member_profile_provider.dart';
import 'package:captone4/provider/member_provider.dart';
import 'package:captone4/screen/profile_screen.dart';
import 'package:captone4/utils/utils.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../Token.dart';

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

    memberId = widget.token.id!;
    accessToken = widget.token.accessToken!;

    ref.read(memberProfileNotifierProvider.notifier).getProfileImage();
    ref.read(memberNotifierProvider.notifier).getMemberInfoFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberProfileNotifierProvider);
    final memberState = ref.watch(memberNotifierProvider);

    return DefaultLayout(
      backgroundColor: const Color(0xFFFAFAFA),
      title: "My Page",
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          // color: Colors.black,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  state.images.isEmpty == true
                      ? _renderMemberInfoTop("empty", memberState)
                      : _renderMemberInfoTop(
                          state.images.last.url, memberState),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: LinearPercentIndicator(
                      percent: memberState.averageScore / 100,
                      // trailing: Text("${memberState.averageScore}"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
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
                            "settings",
                          ),
                          _generateCategoryIcon(
                            const Icon(Icons.question_mark),
                            "FAQ",
                          ),
                          _generateCategoryIcon(
                            const Icon(Icons.info_rounded),
                            "information",
                          ),
                          _generateCategoryIcon(
                            const Icon(Icons.logout),
                            "logout",
                          ),
                        ],
                      ),
                    ),
                  )
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
        ),
      ),
    );
  }

  Widget _renderMemberInfoTop(String images, MemberModel member) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              token: widget.token,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Column(
            children: [
              member.nickname != ""
                  ? Text(
                      member.nickname,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700),
                    )
                  : const Text(
                      "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
              Text(
                "@" + member.memberId.toString(),
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _generateMemberInfoIcon(3, "Tickets"),
              _generateMemberInfoIcon(23, "Followings"),
              _generateMemberInfoIcon(3, "Followers"),
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
            SizedBox(
              width: getMediaWidth(context) * 0.4,
              child: Row(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
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
          style: TextStyle(fontSize: 20),
        ),
        Text(
          key,
          style: TextStyle(fontSize: 15, color: Colors.grey),
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
