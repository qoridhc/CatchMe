import 'package:captone4/color_scheme.dart';
import 'package:captone4/swipe.dart';
import 'package:captone4/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catch Me',
      theme: lightThemeDataCustom,
      home: Scaffold(
        extendBodyBehindAppBar: true, // AppBar 뒤쪽에 화면 보일 수 있게 함.
        appBar: AppBar(
          title: const Text(
            'Catch Me',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 40, color: Colors.white),
          ),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
          ),
          elevation: 0,
          // backgroundColor: Colors.transparent,
        ),
        body: const Text('Main Page'),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title,
//           style: const TextStyle(fontFamily: 'Pacifico', fontSize: 40),
//         ),
//         shape: const ContinuousRectangleBorder(
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(50),
//               bottomRight: Radius.circular(50)),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[
//             Swipe(),
//           ],
//         ),
//       ),
//     );
//   }
// }
