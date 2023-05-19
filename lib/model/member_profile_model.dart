import '../const/data.dart';

class MemberProfileModel {
  final count;
  final List<MemberProfileImage> images;

  MemberProfileModel({
    required this.count,
    required this.images,
  });

  factory MemberProfileModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return MemberProfileModel(
      count: json['count'],
      images: json["data"]
          .map<MemberProfileImage>(
            (x) => MemberProfileImage.fromJson(json: x),
          )
          .toList(),
    );
  }
}

class MemberProfileImage {
  final imageId;
  final url;

  MemberProfileImage({
    required this.imageId,
    required this.url,
  });

  factory MemberProfileImage.fromJson({
    required Map<String, dynamic> json,
  }) {
    return MemberProfileImage(
      imageId: json['imageId'],
      url: "http://$ip/"+json['url'],
    );
  }
}
