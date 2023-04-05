import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:captone4/login_platform.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

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

  void signInWithNaver() async {
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

  void signOut() async {
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

    return Scaffold(
      backgroundColor: Color(0xffEEDDD6),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('asset/img/login_back.png'),
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
                              onPressed: buttonLoginPressed,
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

  Future<void> buttonLoginPressed() async {
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

  Widget _loginButton(String path, VoidCallback onTap) {
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
