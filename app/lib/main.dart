import 'dart:ffi';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: MainApp()));
}

class Entry {
  final String text;
  final DateTime date;

  Entry(this.text, this.date);

  String getEntryTime() {
    return DateFormat.jm().format(date);
  }
}

class AppState extends ChangeNotifier {
  var color =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  List<Entry> entries = [];
  String currentText = "";

  void updateColor(Color newColor) {
    color = newColor;
    notifyListeners();
  }

  void addEntry(String entry) {
    entries.add(Entry(entry, DateTime.now()));
    notifyListeners();
  }

  void updateCurrentText(String newText) {
    currentText = newText;
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return MaterialApp(
        title: "Here's a thought",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: appState.color),
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;
  TextEditingController _textController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2030, 12),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String getDate() {
    return Jiffy.parseFromDateTime(_selectedDate ?? DateTime.now())
        .format(pattern: 'MMM do yy');
  }

  Widget displayRibbon(BuildContext context) {
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
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.calendar_view_week_outlined,
                  color: appState.color,
                  size: 45,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget displayEntries(BuildContext context) {
    var appState = context.watch<AppState>();

    if (appState.entries.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            "No entries yet",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return Expanded(
        child: ListView.builder(
      itemCount: appState.entries.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            contentPadding: EdgeInsets.all(25),
            title: Text(appState.entries[index].text),
            subtitle: Text(appState.entries[index].getEntryTime()),
          ),
        );
      },
    ));
  }

  void onTextSubmission(BuildContext context, String value) {
    var appState = context.watch<AppState>();
    appState.addEntry(value);
    _textController.clear();
  }

  Widget displayTextInput(BuildContext context) {
    var appState = context.watch<AppState>();
    return Align(
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
                controller: _textController,
                decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
                onSubmitted: (value) => {
                  onTextSubmission(context, value),
                },
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () => {
                // onTextSubmission(context, value),
              },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          displayRibbon(context),
          displayEntries(context),
          displayTextInput(context),
        ],
      ),
    );
  }
}
