import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';

import '../model/member_model.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({Key? key}) : super(key: key);

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  List<MemberModel> users = [
    MemberModel(
      memberId: '1',
      nickname: 'suzy',
      imageUrls: 'assets/images/test_img/4.jpg',
      birthYear: '1994',
      introduction:
      '모험을 즐기는 여행자이자 음식 애호가입니다. 함께 새로운 여정을 떠나고 다양한 음식을 맛보며 함께할 파트너를 찾고 있어요. 새로운 문화를 경험하고 독특한 요리를 시도하며 잊지 못할 추억을 만들어나가는 것에 열정을 가지고 있어요. 다음 여행 계획을 세우느라 바쁘지 않을 때에는 자연에서 하이킹을 즐기거나 요가를 하거나 좋은 책과 함께한 시간을 즐기곤 해요. 즉흥적이고 웃음이 넘치며 좋은 대화를 나눌 수 있는 분을 찾고 있습니다. 함께 세상을 탐험해보는 건 어떠세요?',
      gender: 'female',
      mbti: 'ISFP',
      averageScore: '100',
    ),
    MemberModel(
      memberId: '2',
      nickname: '차은우',
      imageUrls: 'assets/images/test_img/5.jpg',
      birthYear: '1997',
      introduction:
      '모험을 즐기는 여행자이자 음식 애호가입니다.\n함께 새로운 여정을 떠나고 다양한 음식을 맛보며 함께할 파트너를 찾고 있어요. \n새로운 문화를 경험하고 독특한 요리를 시도하며 잊지 못할 추억을 만들어나가는 것에 열정을 가지고 있어요. \n다음 여행 계획을 세우느라 바쁘지 않을 때에는 자연에서 하이킹을 즐기거나 요가를 하거나 좋은 책과 함께한 시간을 즐기곤 해요. \n즉흥적이고 웃음이 넘치며 좋은 대화를 나눌 수 있는 분을 찾고 있습니다. 함께 세상을 탐험해보는 건 어떠세요?',
      gender: 'male',
      mbti: 'ISFP',
      averageScore: '1',
    ),
    MemberModel(
      memberId: '2',
      nickname: '차은우',
      imageUrls: 'assets/images/test_img/5.jpg',
      birthYear: '19970330',
      introduction:
      '모험을 즐기는 여행자이자 음식 애호가입니다. 함께 새로운 여정을 떠나고 다양한 음식을 맛보며 함께할 파트너를 찾고 있어요. 새로운 문화를 경험하고 독특한 요리를 시도하며 잊지 못할 추억을 만들어나가는 것에 열정을 가지고 있어요. 다음 여행 계획을 세우느라 바쁘지 않을 때에는 자연에서 하이킹을 즐기거나 요가를 하거나 좋은 책과 함께한 시간을 즐기곤 해요. 즉흥적이고 웃음이 넘치며 좋은 대화를 나눌 수 있는 분을 찾고 있습니다. 함께 세상을 탐험해보는 건 어떠세요?',
      gender: 'male',
      mbti: 'ISFP',
      averageScore: '1',
    ),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
=======
    List<MemberModel> users = [
      MemberModel(
        memberId: '1',
        nickname: 'suzy',
        imageUrls: ['assets/images/test_img/4.jpg'],
        birthYear: '1994',
        introduction:
            '모험을 즐기는 여행자이자 음식 애호가입니다. 함께 새로운 여정을 떠나고 다양한 음식을 맛보며 함께할 파트너를 찾고 있어요. 새로운 문화를 경험하고 독특한 요리를 시도하며 잊지 못할 추억을 만들어나가는 것에 열정을 가지고 있어요. 다음 여행 계획을 세우느라 바쁘지 않을 때에는 자연에서 하이킹을 즐기거나 요가를 하거나 좋은 책과 함께한 시간을 즐기곤 해요. 즉흥적이고 웃음이 넘치며 좋은 대화를 나눌 수 있는 분을 찾고 있습니다. 함께 세상을 탐험해보는 건 어떠세요?',
        gender: 'female',
        mbti: 'ISFP',
        averageScore: 100.0,
      ),
      MemberModel(
        memberId: '2',
        nickname: '차은우',
        imageUrls: ['assets/images/test_img/5.jpg'],
        birthYear: '1997',
        introduction:
            '모험을 즐기는 여행자이자 음식 애호가입니다.\n함께 새로운 여정을 떠나고 다양한 음식을 맛보며 함께할 파트너를 찾고 있어요. \n새로운 문화를 경험하고 독특한 요리를 시도하며 잊지 못할 추억을 만들어나가는 것에 열정을 가지고 있어요. \n다음 여행 계획을 세우느라 바쁘지 않을 때에는 자연에서 하이킹을 즐기거나 요가를 하거나 좋은 책과 함께한 시간을 즐기곤 해요. \n즉흥적이고 웃음이 넘치며 좋은 대화를 나눌 수 있는 분을 찾고 있습니다. 함께 세상을 탐험해보는 건 어떠세요?',
        gender: 'male',
        mbti: 'ISFP',
        averageScore: 1.0,
      ),
      MemberModel(
        memberId: '2',
        nickname: '차은우',
        imageUrls: ['assets/images/test_img/5.jpg'],
        birthYear: '19970330',
        introduction:
            '모험을 즐기는 여행자이자 음식 애호가입니다. 함께 새로운 여정을 떠나고 다양한 음식을 맛보며 함께할 파트너를 찾고 있어요. 새로운 문화를 경험하고 독특한 요리를 시도하며 잊지 못할 추억을 만들어나가는 것에 열정을 가지고 있어요. 다음 여행 계획을 세우느라 바쁘지 않을 때에는 자연에서 하이킹을 즐기거나 요가를 하거나 좋은 책과 함께한 시간을 즐기곤 해요. 즉흥적이고 웃음이 넘치며 좋은 대화를 나눌 수 있는 분을 찾고 있습니다. 함께 세상을 탐험해보는 건 어떠세요?',
        gender: 'male',
        mbti: 'ISFP',
        averageScore: 1.0,
      ),
    ];
>>>>>>> Stashed changes




    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double availableHeight = screenHeight - appBarHeight;
    int userAge = 2023 - int.parse(users[currentIndex].birthYear);

    return DefaultLayout(
      title: "Main",
      child: Center(
        child: Dismissible(
          key: ValueKey(currentIndex >= 0 && currentIndex <= users.length
              ? users[currentIndex]
              : null),
          direction: DismissDirection.horizontal,
          background: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: const [
                  Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    '  Nope',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 30),
                  Text('  Like',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ],
              ),
            ),
          ),
          onDismissed: (direction) {
            if(direction == DismissDirection.endToStart)
              {
                setState(() {
                  if (currentIndex < users.length) {
                    currentIndex += 1;
                    print("다음");
                  }
                  else if (currentIndex >= users.length) {
                    currentIndex = 0;
                  }

                });
              }

          },
          child: Card(
            child: ListView(
              children: [
                Column(
                  children: [
                    Image.asset(
                      users[currentIndex].imageUrls.last,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenWidth / 4,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            users[currentIndex].nickname,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth / 3,
                          child: Text(
                            userAge.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          width: screenWidth / 3,
                          child: Text(
                            users[currentIndex].mbti,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        users[currentIndex].introduction!,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // child: Image.asset(users[currentIndex].imageUrls),
    );
  }
}
