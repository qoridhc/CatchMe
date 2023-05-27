import 'package:captone4/Token.dart';
import 'package:captone4/const/data.dart';
import 'package:captone4/model/member_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memberProfileNotifierProvider =
    StateNotifierProvider<MemberProfileNotifier, MemberProfileModel>((ref) {
  final dio = ref.watch(dioProvider);
  final token = ref.watch(tokenProvider);

  return MemberProfileNotifier(
    dio: dio,
    token: token,
  );
});

class MemberProfileNotifier extends StateNotifier<MemberProfileModel> {
  final Dio dio;
  final Token token;

  MemberProfileNotifier({
    required this.dio,
    required this.token,
  }) : super(
          MemberProfileModel(
            count: -1,
            images: [],
          ),
        );

  void toggleChange() {
    state = MemberProfileModel(
      count: 1000,
      images: [
        MemberProfileImage(
            imageId: 100,
            url:
                "https://talkimg.imbc.com/TVianUpload/tvian/TViews/image/2023/01/16/251e36fa-ad24-45a9-b771-1bd8e15f2e29.jpg"),
      ],
    );
  }

  void getProfileImage() async {
    print("_getProfileImageFromServer 실행");

    try {
      final resp = await dio.get(
        'http://$ip/api/v1/members/${token.id}/images',
        options: Options(
          headers: {
            'authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      state = MemberProfileModel.fromJson(json: resp.data);
      print("프로필 이미지 가져오기 성공");
    } on DioError catch (e) {
      print("에러발생");
      print(e);
      rethrow;
    }
  }
}
