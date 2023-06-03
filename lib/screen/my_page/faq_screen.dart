import 'package:auto_size_text/auto_size_text.dart';
import 'package:captone4/const/colors.dart';
import 'package:captone4/utils/utils.dart';
import 'package:captone4/widget/default_layout.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      title: "",
      child: Column(
        children: [
          Container(
            height: getMediaHeight(context) * 0.3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "어떻게 도와 드릴까요?",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: "BMJua",
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: getMediaHeight(context) * 0.7,
            width: getMediaWidth(context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "자주 하는 질문",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        fontFamily: "BMJua"),
                  ),
                ),
                _createDropdownItem(
                  "티켓은 어디에 사용되나요?",
                  "티켓은 1:1 매칭을 하는데 사용됩니다.",
                  getMediaHeight(context) * 0.04,
                ),
                _customDivier(),
                _createDropdownItem(
                  "티켓은 어떻게 얻나요?",
                  "티켓은 3:3 매칭 게임에서 제리(속이는사람)을 찾거나, 본인이 제리가 되어 모든 사람을 속이는 경우 얻을 수 있습니다.",
                  getMediaHeight(context) * 0.1,
                ),
                _customDivier(),
                _createDropdownItem(
                  "프로필은 어떻게 수정하나요??",
                  "마이페이지에서 프로필 이미지를 선택하면 프로필 이미지 및 세부 사항 변경 페이지로 이동합니다.",
                  getMediaHeight(context) * 0.1,
                ),
                _customDivier(),
                _createDropdownItem(
                  "3:3 매칭은 어떻게 시작하나요?",
                  "하단 네이게이션바에 하트모양을 누르면 \n매칭 큐가 시작됩니다.",
                  getMediaHeight(context) * 0.065,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _createDropdownItem(String question, String answer, double customHeight) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Text(
            question,
            style: TextStyle(
              fontSize: 16,
              // color: Theme.of(context).hintColor,
            ),
          ),
          items: [
            DropdownMenuItem(
              value: "item",
              child: Container(
                // color: Colors.black,
                // width: getMediaWidth(context) * 0.75,
                height: getMediaHeight(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    answer,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            )
          ],
          onChanged: (value) {},
          buttonStyleData: ButtonStyleData(
            width: getMediaWidth(context) * 0.8,
          ),
          dropdownStyleData: DropdownStyleData(
            offset: Offset(-10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: [customHeight],
          ),
        ),
      ),
    );
  }

  _customDivier() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Divider(
        thickness: 1,
      ),
    );
  }
}
