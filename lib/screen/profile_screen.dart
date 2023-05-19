import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:captone4/const/colors.dart';
import 'package:captone4/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

import '../const/data.dart';

class ProfileScreen extends StatefulWidget {
  final tmpMemberId;
  final tmpAccessToken;
  final profileImage;


  ProfileScreen({
    required this.tmpMemberId,
    required this.tmpAccessToken,
    this.profileImage,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? _pickedFile;

  final TextStyle ts = TextStyle(
    fontSize: 25,
    fontFamily: 'BMJua',
  );

  final TextStyle textFieldStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w800);

  final TextEditingController introduceController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  final String introduce = "아이즈원 김민주";
  final String question = "나의 취미는 OOO 입니다";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    introduceController.text = introduce;
    questionController.text = question;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => _renderDialog(),
                  );
                },
                child: Container(
                  // color: Colors.black,
                  height: getMediaHeight(context) * 0.6,
                  width: getMediaWidth(context),
                  child: _pickedFile == null
                      ? Container(
                    child: Center(
                      child: Text("프로필 이미지를 선택해주세요"),
                    ),
                  )
                      : Image.file(
                          File(_pickedFile!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "김민주 / 22",
                          style: ts,
                        ),
                        Text(
                          "ISTP",
                          style: ts,
                        ),
                      ],
                    ),
                    _renderTextFormField("한줄 소개", introduceController),
                    _renderTextFormField("한줄 질문 : 나의 취미는?", questionController),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _renderTextFormField(String title, TextEditingController controller) {
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
        'http://$ip/api/v1/members/${widget.tmpMemberId}/images',
        options: Options(
          headers: {
            'authorization': 'Bearer ${widget.tmpAccessToken}',
          },
        ),
        data: formData,
      );
      print("이미지 전송 성공");
    } on DioError catch (e) {
      print(e);
    }
  }
}
