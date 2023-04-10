class User {
  Map<String, dynamic> ?data;
  // 우선 이 정도만 설정해놨고 앞으로 늘려나갈 예정
  User({required String name, required String photo, required int age, String? mbti, String? status, required String info}) {
    data = {
      'name': name,
      'photo': photo,
      'age': age,
      'mbti': mbti,
      'status': status,
      'info': info,
    };
  }
}
