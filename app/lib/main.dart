import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:math' as math;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
          title: "Here's a thought",
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          ),
          home: HomePage()),
    );
  }
}

class AppState extends ChangeNotifier {
  var current = WordPair.random();
  var color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

class HomePage extends StatelessWidget {
  String getDate() {
    return Jiffy.now().format(pattern: 'MMM do yy');
  }

  Widget calendarButton(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  getDate(),
                  style: TextStyle(fontSize: 25, color: appState.color),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.calendar_view_week_rounded,
                  size: 70,
                  color: appState.color,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: [calendarButton(context)],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 60,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: appState.color,
                    elevation: 0,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
