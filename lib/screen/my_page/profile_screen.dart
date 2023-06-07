import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/const/colors.dart';
import 'package:captone4/const/mbti.dart';
import 'package:captone4/exception/HasNotNicknameChangeCouponException.dart';
import 'package:captone4/provider/member_profile_provider.dart';
import 'package:captone4/provider/member_provider.dart';
import 'package:captone4/screen/root_tab.dart';
import 'package:captone4/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../Token.dart';
import '../../const/data.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final Token token;
  bool? fromLogin = false;

  ProfileScreen({
    required this.token,
    this.fromLogin,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? _pickedFile;

  List<String> mbti = Mbti.values.map((e) => e.name).toList();
  String selectedMbti = "NONE";

  final List<String> genderItems = [
    'Male',
    'Female',
  ];

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

    print("widget.fromLogin : ${widget.fromLogin}");

    print("ProfileScreen 진입");
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

  void renderMemberInfo() async {
    final memberInfo = await ref
        .read(memberNotifierProvider.notifier)
        .getMemberInfoFromServer();

    if (memberInfo.introduction != null) {
      introduceController.text = memberInfo.introduction!;
    }

    nicknameController.text = memberInfo.nickname.length > 4
        ? memberInfo.nickname.substring(0, 4)
        : memberInfo.nickname;

    selectedMbti = memberInfo.mbti;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberProfileNotifierProvider);
    final memberState = ref.watch(memberNotifierProvider);

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

    print("memberBirth : ");

    print(memberState.birthYear);

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
                          builder: (context) => _renderImageDialog(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: getMediaWidth(context) * 0.2,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                      ),
                                      style: ts,
                                      controller: nicknameController,
                                      validator: (val){
                                        print("validate");
                                        print(val);
                                      },
                                    ),
                                  ),
                                  if (memberState.birthYear.isNotEmpty)
                                    Text(
                                      "/ ${DateTime.now().year - int.parse(memberState.birthYear)}",
                                      style: ts,
                                    ),
                                ],
                              ),
                              Container(
                                // color: Colors.black,
                                width: getMediaWidth(context) * 0.28,
                                child: DropdownButtonFormField2(
                                  value: selectedMbti.isNotEmpty
                                      ? selectedMbti
                                      : null,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  items: mbti
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Container(
                                              // color: Colors.black,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select gender.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    selectedMbti = value!;
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: getMediaHeight(context) * 0.05,
                                    width: getMediaWidth(context) * 0.2,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: getMediaHeight(context) / 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
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
                  height: getMediaHeight(context) * 0.06,
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text("save"),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (state.images.isEmpty) {
                          print("ProfileScreen - 프로필이미지 미등록 상태");

                          showDialog(
                            context: context,
                            builder: (context) =>
                                _renderDefaultDialog("프로필 이미지 등록은 필수입니다."),
                          );

                          return;
                        }

                        try {
                          final resp = await ref
                              .read(memberNotifierProvider.notifier)
                              .postMemberInfoUpdate(
                                nicknameController.text,
                                introduceController.text,
                                selectedMbti,
                              );
                        } on HasNotNicknameChangeCouponException catch (e) {
                          // 닉네임 권한이 없는 상태에서 (이미 닉네임 변경을 한 경우) 다시 닉네임 변경을 시도한 경우
                          showDialog(
                            context: context,
                            builder: (context) =>
                                _renderDefaultDialog("닉네임은 한번 이상 변경 불가능합니다."),
                          );

                          return;
                        }

                        // 로그인 스크린에서 프로필 설정을 위해 강제로 넘긴경우 프로필 설정이 완료되면 pop하고 RootTab으로
                        if (widget.fromLogin == true) {
                          print("widget.fromLogin : ${widget.fromLogin}");

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RootTab(
                                token: widget.token,
                              ),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
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

  _renderImageDialog() {
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
          SizedBox(height: 10),
          Text("변경하실 방법을 선택해주세요"),
          Container(
            width: MediaQuery.of(context).size.width,
            height: getMediaHeight(context) * 0.07,
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

  _renderDefaultDialog(String content) {
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
          SizedBox(height: 15),
          Text(content),
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
              maxLines: 3,
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

    final XFile? selectedImage = file;

    // selectedImages.add(file);

    final MultipartFile files = MultipartFile.fromFileSync(
      selectedImage!.path,
      contentType: MediaType("image", "jpeg"),
    );

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

      print("이미지 전송 성공");
      ref.read(memberProfileNotifierProvider.notifier).getProfileImage();
    } on DioError catch (e) {
      print(e);
    }
  }
}
