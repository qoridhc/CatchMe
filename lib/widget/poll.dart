import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_polls/simple_polls.dart';
import 'package:confetti/confetti.dart';

// import 'package:flutter_polls/flutter_polls.dart';

class PollsDemo extends StatefulWidget {
  final int chatTime;
  const PollsDemo({
    super.key,
    required this.chatTime,
  });
  @override
  _PollsDemoState createState() => _PollsDemoState();
}

class _PollsDemoState extends State<PollsDemo> {
  late Timer _timer;
  bool isExpanded = false;
  late int chattingTime;
  late int totalTime;
  var users = ['여자 1호', '여자 2호', '여자 3호', '남자 1호', '남자 2호', '남자 3호'];
  var guessedJerry = [];
  late var votes;
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    chattingTime = widget.chatTime;
    int num = chattingTime;
    totalTime = chattingTime;
    _handleTimer();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isExpanded = true;
      });
    });

    ConfettiWidget(
      confettiController: controller,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple,
      ],
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: false,
      maxBlastForce: 30,
      minBlastForce: 5,
      blastDirection: 3.14 / 2,
      emissionFrequency: 0.05,
      numberOfParticles: 50,
      gravity: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  String user = "user@gmail.com";
  Map usersWhoVoted = {
    'test@gmail.com': 1,
    'deny@gmail.com': 3,
    'kent@gmail.com': 2,
    'xyz@gmail.com': 3
  };
  String creator = "admin@gmail.com";
  String announcement = "제리에게 투표해주세요";

  void _handleTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (chattingTime <= 8) {
            isExpanded = true;
          }
          if (chattingTime <= -3) {
            _timer.cancel();
            announcement = "제리는 ${guessedJerry[0]}였습니다!!";
          } else {
            chattingTime = chattingTime - 1;
            print("chatting time left ${chattingTime}");
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: ExpansionTile(
            // initiallyExpanded: isExpanded,
            // onExpansionChanged: (expanded) {
            //   if (chattingTime <= 8) {
            //     setState(() {
            //       isExpanded = true;
            //     });
            //   }
            // },
            title: Text('$announcement',
                style: TextStyle(color: Colors.grey[700])),
            children: [
              SimplePollsWidget(
                onSelection:
                    (PollFrameModel model, PollOptions? selectedOptionModel) {
                  print('전체 투표 수 : ${model.totalPolls}');
                  print('선택된 옵션 : ${selectedOptionModel!.label}');
                  print(selectedOptionModel.pollsCount);
                  votes = model.options[0].pollsCount;
                  guessedJerry.add(model.options[0].label);
                  for (int i = 1; i < users.length - 1; i++) {
                    if (model.options[i].pollsCount > votes) {
                      votes = model.options[i].pollsCount;
                      print(votes);
                      guessedJerry.clear();
                      guessedJerry.add(model.options[i].label);
                    } else if (model.options[i].pollsCount == votes) {
                      guessedJerry.add(model.options[i].label);
                    }
                  }
                  print('가장 투표 많이 받은 사람 : $guessedJerry, 받은 표: $votes');
                    if (chattingTime <= 3) {
                  if (guessedJerry[0] == selectedOptionModel.label) {
                      print("chatting time is ${chattingTime}");
                      print('you got it');
                      controller.play();
                      announcement = "제리는 ${guessedJerry[0]}였습니다!!";
                    }
                  }
                },
                model: PollFrameModel(
                  title: Container(
                    alignment: Alignment.centerLeft,
                  ),
                  totalPolls: 5,
                  hasVoted: false,
                  editablePoll: true,
                  // endTime: DateTime.now().toUtc().add(const Duration(minutes: 15)),
                  endTime: DateTime.now()
                      .toUtc()
                      .add(Duration(seconds: totalTime + 3)),
                  options: <PollOptions>[
                    /// Configure options here
                    PollOptions(
                      label: users[0],
                      pollsCount: 1,

                      /// Polls received by that option.
                      isSelected: false,

                      /// If poll selected.
                      id: 1,

                      /// Option id.
                    ),
                    PollOptions(
                      label: users[1],
                      pollsCount: 2,
                      isSelected: false,
                      id: 2,
                    ),
                    PollOptions(
                      label: users[2],
                      pollsCount: 0,
                      isSelected: false,
                      id: 3,
                    ),
                    PollOptions(
                      label: users[3],
                      pollsCount: 0,
                      isSelected: false,
                      id: 4,
                    ),
                    PollOptions(
                      label: users[4],
                      pollsCount: 2,
                      isSelected: false,
                      id: 5,
                    ),
                    PollOptions(
                      label: users[5],
                      pollsCount: 0,
                      isSelected: false,
                      id: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
          ],
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          maxBlastForce: 30,
          minBlastForce: 5,
          blastDirection: 3.14 / 2,
          emissionFrequency: 0.05,
          numberOfParticles: 50,
          gravity: 1,
        ),
        ConfettiWidget(
          confettiController: controller,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
          ],
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          maxBlastForce: 30,
          minBlastForce: 5,
          blastDirection: 350,
          emissionFrequency: 0.05,
          numberOfParticles: 50,
          gravity: 1,
        ),
      ],
    );
  }
}
