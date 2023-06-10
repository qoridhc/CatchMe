import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShrinkButton extends StatefulWidget {
  // final Widget child;
  final Function onPressed;
  final double shrinkScale;
  final String userName;

  ShrinkButton({
    // required this.child,
    required this.onPressed,
    required this.userName,
    this.shrinkScale = 0.6,
  });

  @override
  _ShrinkButtonState createState() => _ShrinkButtonState();
}

class _ShrinkButtonState extends State<ShrinkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
  }

  var chosenUser = [];
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    var customHeight = MediaQuery.of(context).size.height / 10;
    var customWidth = (MediaQuery.of(context).size.width * 7 / 8) / 2;
    var backgroundColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        _controller.forward();
        Future.delayed(Duration(milliseconds: 200), () {
          _controller.reverse();
        });
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.0,
          end: widget.shrinkScale,
        ).animate(_controller),
        child: SizedBox(
          width: customWidth,
          height: customHeight,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                clicked = !clicked;
                if (clicked == true) {
                  chosenUser.clear();
                  chosenUser.add(widget.userName);
                  submitMafia();
                }
                if (kDebugMode) {
                  widget.onPressed();
                  print('${widget.userName} $clicked');
                }
              });
            },
            child: Text(
              widget.userName,
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  clicked ? Colors.black : Theme.of(context).primaryColor,
              disabledForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
            ),
          ),
        ),
      ),
    );
  }

  void submitMafia() {
    print('${chosenUser[0]}를 마피아로 투표하셨습니다');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
