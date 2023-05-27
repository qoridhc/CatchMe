import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/const/colors.dart';
import 'package:captone4/provider/member_profile_provider.dart';
import 'package:captone4/provider/member_provider.dart';
import 'package:captone4/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../Token.dart';
import '../const/data.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final Token token;

  ProfileScreen({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? _pickedFile;

  final TextStyle ts = TextStyle(
    fontSize: 25,
    fontFamily: 'BMJua',
  );

  final TextStyle textFieldStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w800);

  late TextEditingController introduceController;
  late TextEditingController nicknameController;
  late TextEditingController mbtiController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    introduceController = TextEditingController();
    nicknameController = TextEditingController();
    mbtiController = TextEditingController();
    _scrollController = ScrollController();

    renderMemberInfo();

    print("========= accessToken ==========");
    print(ref.read(tokenProvider).accessToken);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    introduceController.dispose();
    super.dispose();
  }

  void renderMemberInfo() {
    final memberState = ref.read(memberNotifierProvider);

    if (memberState.introduction != null) {
      introduceController.text = memberState.introduction!;
    }

    nicknameController.text = memberState.nickname;

    mbtiController.text = memberState.mbti;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberProfileNotifierProvider);
    final memberState = ref.watch(memberNotifierProvider);
    //
    // if (memberState.introductionㄴ != null)
    //   introduceController.text = memberState.introduction!;
    // nicknameController.text = memberState.nickname;

    // notifier로 자동 리빌드가 안되서 일단 listen으로 setState실행해서 수동 리빌드
    // ref.listen(
    //   MemberProfileNotifierProvider,
    //   (previous, next) {
    //     print("변경전 :${previous!.images.last.url}");
    //     print("변경후 :${next.images.last.url}");
    //     setState(() {});
    //   },
    // );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      child: Container(
                          height: getMediaHeight(context) * 0.6,
                          width: getMediaWidth(context),
                          child: state.images.isEmpty
                              ? Center(
                                  child: Text("프로필 이미지를 선택해주세요"),
                                )
                              : CachedNetworkImage(
                                  imageUrl: state.images.last.url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 40.0,
                                      height: 40.0,
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                )),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => _renderDialog(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    // color: Colors.black,
                                    width: getMediaWidth(context) * 0.2,
                                    child: TextFormField(
                                      // maxLength: 4,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      style: ts,
                                      controller: nicknameController,
                                    ),
                                  ),
                                  Text(
                                    "/ ${DateTime.now().year - int.parse(memberState.birthYear)}",
                                    style: ts,
                                  ),
                                ],
                              ),
                              // Text(
                              //   "${memberState.nickname.substring(0,3)} / ${DateTime.now().year - int.parse(memberState.birthYear)}",
                              //   style: ts,
                              // ),
                              Container(
                                // color: Colors.black,
                                width: getMediaWidth(context) * 0.2,
                                child: TextFormField(
                                  // maxLength: 4,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: ts,
                                  controller: mbtiController,
                                ),
                              ),
                            ],
                          ),
                          _renderContentsFormField(
                            "한줄 소개",
                            introduceController,
                          ),
                          // _renderContentsFormField(
                          //     "한줄 질문 : 나의 취미는?", questionController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                child: SizedBox(
                  width: getMediaWidth(context) * 0.7,
                  height: 40,
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text("save"),
                      onPressed: () {
                        ref
                            .read(memberNotifierProvider.notifier)
                            .postMemberInfoUpdate(
                              nicknameController.text,
                              introduceController.text,
                              mbtiController.text,
                            );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _renderDialog() {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // color: Colors.red,
                child: Text(
                  "프로필 이미지 변경",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text("변경하실 방법을 선택해주세요"),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                _getCameraImage();
              },
              child: Center(
                child: Text(
                  "Camera",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                _getPhotoLibraryImage();
              },
              child: Center(
                child: Text(
                  "Gallery",
                  style: TextStyle(
                    fontSize: 18.0,
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

  // Widget _renderProfileFormfield()

  Widget _renderContentsFormField(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: textFieldStyle.copyWith(color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });

      uploadUserProfileImage(pickedFile);

      Navigator.of(context).pop();
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });

      uploadUserProfileImage(pickedFile);

      Navigator.of(context).pop();
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Future<dynamic> uploadUserProfileImage(dynamic file) async {
    print("프로필 사진을 서버에 업로드 합니다.");

    final List<XFile?> selectedImages = [];

    selectedImages.add(file);

    final List<MultipartFile> files = selectedImages
        .map(
          (e) => MultipartFile.fromFileSync(
            e!.path,
            contentType: MediaType("image", "jpeg"),
          ),
        )
        .toList();

    var formData = FormData.fromMap({"images": files});

    Dio dio = Dio();

    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;

    try {
      final res = await dio.post(
        'http://$ip/api/v1/members/${widget.token.id}/images',
        options: Options(
          headers: {
            'authorization': 'Bearer ${widget.token.accessToken}',
          },
        ),
        data: formData,
      );
      //      state.imageId = res.data["data"].last["url"];
      print("이미지 전송 성공");
      ref.read(memberProfileNotifierProvider.notifier).getProfileImage();
      // final state = ref.read(imagePro.notifier).state;
      // state.imageId = res.data["data"].last["imageId"];
      // state.url = res.data["data"].last["url"];
    } on DioError catch (e) {
      print(e);
    }
  }
}
