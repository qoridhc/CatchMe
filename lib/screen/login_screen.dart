import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:captone4/login_platform.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;
import 'dart:convert';

class Token{
  final String accessToken;
  final String type;

  Token({required this.accessToken,
  required this.type});

  factory Token.fromJson(Map<String, dynamic> json){
    return Token(accessToken: json["accessToken"], type: json["type"]);
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  String? accesToken;
  String? expiresAt;
  String? tokenType;
  String? name;
  String? refreshToken;

  LoginPlatform _loginPlatform = LoginPlatform.none;

  final idController = TextEditingController();
  final pwController = TextEditingController();

  void signInWithNaver() async {   //네이버 로그인 관리
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();

      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;

      if (result.status == NaverLoginStatus.loggedIn) {
        print('accessToken = ${result.accessToken}');
        print('gender = ${result.account.gender}');
        print('birthyear = ${result.account.birthyear}');
        print('phone = ${result.account.mobile}');

        setState(() {
          _loginPlatform = LoginPlatform.naver;
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void signOut() async {  //여러 로그인 방식 관리
    switch (_loginPlatform) {
      case LoginPlatform.facebook:
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    //화면 제작

    return Scaffold(  //화면 그리기
      backgroundColor: Color(0xffEEDDD6),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/login_back.png'),
              )),
            ),
            Container(

              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.none,
                    image: AssetImage('assets/images/Main_logo.png'),
                  )),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: Color(0xffFF6961),
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "로그인",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 2/3,
                            child: OutlinedButton(
                              onPressed: buttonNaverLoginPressed,  //로그인 함수 실행
                              child: Text(
                                "Naver Login",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                            ),
                          ),
                          SizedBox(   //ID입력
                            width: MediaQuery.of(context).size.width * 2/3,
                            child: OutlinedButton(
                              onPressed: buttonLoginPressed,
                              child: TextField(
                                controller: idController,
                                decoration: InputDecoration(
                                  labelText: 'ID'
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side:
                                          BorderSide(color: Colors.red)))),
                            ),
                          ),
                          SizedBox(  //password입력
                            width: MediaQuery.of(context).size.width * 2/3,
                            child: OutlinedButton(
                              onPressed: buttonLoginPressed,
                              child: TextField(
                                controller: pwController,
                                decoration: InputDecoration(
                                    labelText: 'Password'
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side:
                                          BorderSide(color: Colors.red)))),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 2/3,
                            child: OutlinedButton(
                              onPressed: buttonLoginPressed,
                              child: Text(
                                "회원 로그인",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Token> buttonLoginPressed() async{
    String userId = idController.text;
    String password = pwController.text;
    var url = "http://10.0.2.2:8080/api/v1/login";

    print(userId);
    print(password);

    try{
      Map data = {"userId": userId, "password" : password};

      var body = json.encode(data);

      final response = await http.post(Uri.parse(url),headers: {"Content-Type": "application/json"}, body: body);
      if(response.statusCode == 200)
        {
          print('로그인 토큰 발행');
          return Token.fromJson(json.decode(response.body));

        }
      else{
        throw Exception('로그인 오류');

      }

    }
    catch(e){
      print(e);
      rethrow;


    }
  }

  Future<void> buttonNaverLoginPressed() async {   //로그인 눌렀을때 동작
    try {
      final NaverLoginResult res = await FlutterNaverLogin.logIn();
      setState(() {
        name = res.account.nickname;
        isLogin = true;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Widget _loginButton(String path, VoidCallback onTap) {  //네이버 로그인 버튼
    return ElevatedButton(
      onPressed: signInWithNaver,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('네이버 로그인'),
    );
  }

  Widget _logoutButton() {
    if (_loginPlatform == LoginPlatform.none) {
      return const SizedBox.shrink();
    } else {
      return ElevatedButton(
        onPressed: signOut,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xff0165E1),
          ),
        ),
        child: const Text('로그아웃'),
      );
    }
  }


}
