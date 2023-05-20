import 'package:flutter/material.dart';
import 'package:captone4/NumberFormatter.dart';
import 'package:flutter/services.dart';

import '../validate.dart';

class joinScreen extends StatefulWidget {
  const joinScreen({Key? key}) : super(key: key);

  @override
  State<joinScreen> createState() => _joinScreenState();
}
enum Gender { male, female }
class _joinScreenState extends State<joinScreen> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final pwCheckController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();
  final eMailController = TextEditingController();
  final birthYearController = TextEditingController();
  List<String> _year = [];
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  Gender? _gender = Gender.male;  //남자 더많으니 처음에 남자로 세팅

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffEEDDD6),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'ID',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      obscureText: true,
                      focusNode: _passwordFocus,
                      keyboardType: TextInputType.visiblePassword,
                      controller: pwController,
                      validator: (value) => CheckValidate().validatePassword(_passwordFocus, value!),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '비밀번호',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      obscureText: true,
                      focusNode: _passwordFocus,
                      keyboardType: TextInputType.visiblePassword,
                      controller: pwCheckController,
                      validator: (value) {
                        if(value == null || value.isEmpty)
                          {
                            return '비밀번호를 입력하세요';
                          }
                        else if(value !=  pwController.text)
                          {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '비밀번호 확인',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      controller: phoneController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, //숫자만!
                        NumberFormatter(), // 자동하이픈
                        LengthLimitingTextInputFormatter(13) //13자리만 입력받도록 하이픈 2개+숫자 11개
                      ],
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '휴대폰 번호',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      controller: eMailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'e-mail',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'nickname',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                  ),
                  Text(
                      '성별',
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('남자'),
                          leading: Radio<Gender>(
                            value: Gender.male,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('여자'),
                          leading: Radio<Gender>(
                            value: Gender.female,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *2/3,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextFormField(
                      controller: birthYearController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: '출생년도',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        )
    );

  }


}
