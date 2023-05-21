import 'package:flutter/material.dart';

import '../widget/default_layout.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Message",
      child: Center(
        child: Text("Chat Page Screen"),
      ),
    );
  }
}
