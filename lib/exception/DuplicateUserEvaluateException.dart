class DuplicateUserEvaluateException implements Exception {
  final String? msg;

  const DuplicateUserEvaluateException([this.msg]); // []: optional positional parameters

  @override
  String toString() => msg ?? 'DuplicateUserEvaluateException';
// ?? : conditional expressions. 앞에꺼가 null 아니면 고거 리턴, 아니면 뒤에꺼
}
