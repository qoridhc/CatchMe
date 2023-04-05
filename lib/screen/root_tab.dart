import 'package:auto_size_text/auto_size_text.dart';
import 'package:captone4/screen/chat_room_screen.dart';
import 'package:captone4/screen/favorite_list_screen.dart';
import 'package:captone4/screen/main_page_screen.dart';
import 'package:captone4/screen/my_page_screen.dart';
import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../const/colors.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with TickerProviderStateMixin {
  late TabController controller;
  final autoSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    // TODO: implement dispose
    super.dispose();
  }

  void tabListener() {
    setState(() {
      _bottomNavIndex = controller.index;
    });
  }

  List<ImageIcon> iconList = [
    //list of icons that required by animated navigation bar.
    ImageIcon(AssetImage('assets/images/icons/main_icon.png')),
    ImageIcon(AssetImage('assets/images/icons/chat_icon.png')),
    ImageIcon(AssetImage('assets/images/icons/favorite_icon.png')),
    ImageIcon(AssetImage('assets/images/icons/my_page_icon.png')),
  ];

  List<Icon> tmp = [

  ];

  List<String> iconText = [
    "Main",
    "Chat",
    "Favorite",
    "My Page",
  ];

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            MainPageScreen(),
            ChatRoomScreen(),
            FavoriteListScreen(),
            MyPageScreen(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.favorite_border_outlined),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        gapLocation: GapLocation.center,
        itemCount: iconList.length,
        // splashSpeedInMilliseconds: 10,
        // height: 65,
        tabBuilder: (int index, bool isActive) {
          // final color = isActive ? Colors.red : Colors.green;
          return Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconList[index],
              // Icon(
              //   ImageIcon(AssetImage("assets/")),
              //   // iconList[index],
              //   size: 24,
              //   color: Colors.black,
              // ),
              const SizedBox(height: 4),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: AutoSizeText(
              //     iconText[index],
              //     maxLines: 2,
              //     style: TextStyle(color: Colors.grey, fontSize: 10),
              //     textAlign: TextAlign.center,
              //     group: autoSizeGroup,
              //   ),
              // )
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        onTap: (int index) {
          controller.animateTo(index);
        },
      ),
    );
  }
}
