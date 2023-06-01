import 'package:captone4/model/like_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Token.dart';
import '../const/data.dart';

final followNotifierProvider =
    StateNotifierProvider<FollowNotifier, List<LikeListModel>>((ref) {
  final dio = ref.watch(dioProvider);
  final token = ref.watch(tokenProvider);

  // final following = ref.watch(followingProvider);
  // final follower = ref.watch(followerProvider);
  //

  return FollowNotifier(
    dio: dio,
    token: token,
    // following: following,
    // follower: follower,
  );
});

class FollowNotifier extends StateNotifier<List<LikeListModel>> {
  final Dio dio;
  final Token token;

  // final LikeListModel following;
  // final LikeListModel follower;

  FollowNotifier({
    required this.dio,
    required this.token,
    // required this.following,
    // required this.follower,
  }) : super(
          [
            LikeListModel(
              count: 0,
              likeList: [],
            ),
            LikeListModel(
              count: 0,
              likeList: [],
            ),
          ],
        );

  // 사용자를 Like하는사람 - following
  void getSendLike() async {
    print("getSendLike 실행");
    final dio = Dio();
    final List<String> ls;

    try {
      final resp = await dio.get(
        'http://$ip/api/v1/classifications?memberId=${token.id}&status=true',
        options: Options(
          headers: {'authorization': 'Bearer ${token.accessToken}'},
        ),
      );
      state.first = LikeListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e);
      rethrow;
    }
  }

  // 사용자를 Like하는사람 - follower
  void getReceivedLike() async {
    print("getReceivedLike 실행");
    final dio = Dio();

    try {
      final resp = await dio.get(
        'http://$ip/api/v1/classifications?targetId=${token.id}&status=true',
        options: Options(
          headers: {'authorization': 'Bearer ${token.accessToken}'},
        ),
      );
      state.last = LikeListModel.fromJson(json: resp.data);
    } on DioError catch (e) {
      print("에러 발생");
      print(e);
      rethrow;
    }
  }
}
