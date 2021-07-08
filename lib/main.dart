import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:untitled10/timer_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final String appTitle = "喫煙情報を入力してください";

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  // String型を保存
  void savaStrings(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // int型を保存
  void saveNumbers(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt(key, value);
    });
  }

  @override
  void initState() {
    super.initState();
    checkData();
  }

  // 次画面遷移時の値
  Map<String, int> nextPageMap = {};

  checkData() {
    void prefValues() async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('smokingNumber') != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TimerPage(nextPageMap)),
        );
      }
    }
    prefValues();
  }

   // validationチェック用GlobalKey
  final _formKey = GlobalKey<FormState>();

  //　カレンダーを設定
  DateTime _date = new DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    if (picked != null) setState(() => _date = picked);
  }

  //
  TimeOfDay _time = new TimeOfDay.now();
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) setState(() => _time = picked);
  }


  List<Widget> widgetList = [
    Center(
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '正しい値を入力してください';
          }
          return null;
        },
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Icon(Icons.accessibility_rounded),
                  border: UnderlineInputBorder(),
                  labelText: '一日の本数を入力してください'),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null ||
                    double.tryParse(value) == null ||
                    int.parse(value) < 1 ||
                    int.parse(value) > 100) {
                  return '数値を入力してください';
                }
              },
              onSaved: (value) {
                saveNumbers("smokingNumber", int.parse(value!));
                nextPageMap.addAll({'smokingNumber': int.parse(value)});
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Icon(Icons.accessibility_rounded),
                  border: UnderlineInputBorder(),
                  labelText: '1箱の値段を入力してください'),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null ||
                    double.tryParse(value) == null ||
                    int.parse(value) < 1 ||
                    int.parse(value) > 1000) {
                  return '正しい値を入力してください';
                }
                return null;
              },
              onSaved: (value) {
                saveNumbers("boxValue", int.parse(value!));
                nextPageMap.addAll({'boxValue': int.parse(value)});
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    //　現在日時を保持する処理
                    DateTime nowDate = new DateTime.now();
                    // 開始年
                    saveNumbers("startYear", nowDate.year);
                    // 開始月
                    saveNumbers("startMonth", nowDate.month);
                    // 開始日
                    saveNumbers("startDay", nowDate.day);
                    // 開始時
                    saveNumbers("startHour", nowDate.hour);
                    // 開始分
                    saveNumbers("startMin", nowDate.minute);
                    // 開始秒
                    saveNumbers("startSec", nowDate.second);
                    // 次画面用の値を設定
                    nextPageMap.addAll({
                      'startYear': nowDate.year,
                      'startMonth':nowDate.month,
                      'startDay'  :  nowDate.day,
                      'startHour': nowDate.hour,
                      'startMin':  nowDate.minute,
                      'startSec' : nowDate.second,
                    });

                    _formKey.currentState!.save();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>TimerPage(nextPageMap)),
                    );
                  }
                },
                child: Text('禁煙開始'),
              ),
            ), // Add TextFormFields and ElevatedButton here.
          ],
        ),
      ),
    );
  }
}
