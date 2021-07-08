import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled10/main.dart';
import 'dart:async';

import 'package:untitled10/timer_page.dart';

class Change extends StatelessWidget {
  const Change({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String appTitle = "変更情報を入力してください";

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

  // データを削除する
  void prefClear() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  // 次画面遷移時の値
  Map<String, int> nextPageMap = {};

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
                  icon: Image.network(
                    'https://illust8.com/wp-content/uploads/2019/09/tabako_suigara_4681-768x672.png',
                    width: 30,
                  ),
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
                  icon: Image.network(
                    'https://1.bp.blogspot.com/-KtVIPGzqFaU/VbnRnEF5z7I/AAAAAAAAwNo/WXdX-AlKG8I/s800/mark_yen_okaikei.png',
                    width: 30,
                  ),
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 15),
                  child: Text(
                    '開始日時',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0, 30.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text((DateFormat('yyyy年MM月dd日')).format(_date)),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      _selectDate(context);
                    },
                    child: Text('日付選択'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0, 30.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(child: Text("${_time.hour}時${_time.minute}分")),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      _selectTime(context);
                    },
                    child: Text('時間選択'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 0),
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      DateTime nowDate = new DateTime.now();
                      String today = nowDate.year.toString() +(nowDate.month.toString().length == 1 ? '0' + nowDate.month.toString(): nowDate.month.toString()) +
                          (nowDate.day.toString().length == 1 ? '0' + nowDate.day.toString() : nowDate.day.toString());

                      String enterDate = _date.year.toString() + (_date.month.toString().length == 1 ? '0' + _date.month.toString() : _date.month.toString()) +
                          (_date.day.toString().length == 1 ? '0' + _date.day.toString() : _date.day.toString());

                      if (int.parse(today) < int.parse(enterDate)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("警告"),
                              content: new Text("本日以前の日付で入力してください"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      // 開始年
                      saveNumbers("startYear", _date.year);
                      // 開始月
                      saveNumbers("startMonth", _date.month);
                      // 開始日
                      saveNumbers("startDay", _date.day);
                      // 開始時
                      saveNumbers("startHour", _time.hour);
                      // 開始分
                      saveNumbers("startMin", _time.minute);

                      // 次画面用の値を設定
                      nextPageMap.addAll({
                        'startYear': _date.year,
                        'startMonth': _date.month,
                        'startDay': _date.day,
                        'startHour': _time.hour,
                        'startMin': _time.minute,
                      });

                      _formKey.currentState!.save();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimerPage(nextPageMap)),
                      );
                    }
                  },
                  child: Text('決定'),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 0),
                  child: Text(
                    'データの削除',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 0),
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  child: const Text('削除'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('警告'),
                        content: const Text('本当に削除してもよろしいでしょうか？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () {
                            Navigator.pop(context, 'OK');
                            prefClear();
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                                new MaterialPageRoute(
                                    builder: (context) => new MyApp()),
                                    (_) => false
                            );
                          },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
