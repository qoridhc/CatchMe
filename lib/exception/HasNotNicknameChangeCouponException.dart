class HasNotNicknameChangeCouponException implements Exception {
  final String? msg;

  const HasNotNicknameChangeCouponException([this.msg]); // []: optional positional parameters

  @override
  String toString() => msg ?? 'HasNotNicknameChangeCouponException';
// ?? : conditional expressions. 앞에꺼가 null 아니면 고거 리턴, 아니면 뒤에꺼
}
