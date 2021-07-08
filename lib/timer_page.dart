import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled10/main.dart';

import 'change.dart';

class TimerPage extends StatelessWidget {

  final Map<String, int> nextPageMap;

  // コンストラクタ
  TimerPage(this.nextPageMap);

  @override
  Widget build(BuildContext context) {
    final String appTitle = "禁煙タイマー";
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          actions: <Widget>[
            IconButton(
              icon : Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>Change()),
                  );
                }
            )
          ],
        ),
        body: MyHomePage(nextPageMap),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {

  final Map<String, int> nextPageMap;
  // コンストラクタ
  MyHomePage(this.nextPageMap);

  @override
_MyHomePageState createState() => _MyHomePageState(nextPageMap);
}

class _MyHomePageState extends State<MyHomePage> {

  final Map<String, int> nextPageMap;
  // コンストラクタ
  _MyHomePageState(this.nextPageMap);

  // 受け取り用変数
  int smokingNumber = 0;
  int boxValue = 0;
  int startYear = 0;
  int startMonth = 0;
  int startDay = 0;
  int startHour = 0;
  int startMin = 0;
  int startSec = 0;

  //　画面出力用変数
  String day = '0';
  String hour = '0';
  String min = '0';
  String sec = '0';
  String smokingNumbers = "0";
  String savingTime = "0";
  String savingMoney = "0";

  @override
  void initState() {
    super.initState();
    Future(() async {
      if (nextPageMap.length != 8) {
        prefValues();
      } else {
        mapValues();
      }
    });
  }

  // 初期値がある場合（情報入力済み）
  void prefValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      smokingNumber =  prefs.getInt('smokingNumber')!;
      boxValue =  prefs.getInt('boxValue')!;
      startYear =  prefs.getInt('startYear')!;
      startMonth =  prefs.getInt('startMonth')!;
      startDay =  prefs.getInt('startDay')!;
      startHour =  prefs.getInt('startHour')!;
      startMin =  prefs.getInt('startMin')!;
      startSec = prefs.getInt('startSec')!;
      calc();
    });
  }
  // 初めての場合、変更後の場合（入力値を設定する）
  void mapValues() {
    setState(() {
      smokingNumber =  nextPageMap['smokingNumber']!;
      boxValue =  nextPageMap['boxValue']!;
      startYear =  nextPageMap['startYear']!;
      startMonth = nextPageMap['startMonth']!;
      startDay =  nextPageMap['startDay']!;
      startHour =  nextPageMap['startHour']!;
      startMin =  nextPageMap['startMin']!;
      startSec =  nextPageMap['startSec']!;
      calc();
    });
  }

void calc() {
  // 開始時刻
  DateTime startDateTime = DateTime(startYear, startMonth, startDay, startHour, startMin, startSec);
  final Duration difference = DateTime.now().difference(startDateTime);
  int sec = difference.inSeconds;
  // 開始してからの日数
  int day = sec ~/ (60 * 60 * 24);

  // 日数以下残りsec（時間）
  int remHour = sec - (60 * 60 * 24 * day);
  int hour =  remHour ~/ (60 * 60);

  // 時間以下残りsec（分）
  int minSec = remHour - (60 * 60 * hour);
  int min = minSec ~/ 60;

  // 残り秒
  int remSec =  minSec - (60 * min);

  // 本数（日数）
  int numberDay = smokingNumber * day;
  // 一時間当たりの本数
  double numberPerOneHour =  smokingNumber / 24;
  // 本数（時間）
  int numberHour = (numberPerOneHour * hour).truncate();
  // 節約した本数
  int number = numberDay + numberHour;

  // 一本当たりの時間
  final int smokingTime = 5;

  // 節約できた時間
  int savingTime = number * smokingTime;
  int savingHour = savingTime ~/ 60;
  int savingMin = savingTime % 60;

  // 節約した金額(箱数）
  int savingMoney =  (number ~/ 20) * boxValue;
  // 節約した金額(残り本数）
  int remSavingMoney = ((boxValue / 20) * (number % 20)).truncate() ;

  this.day = day.toString();
  this.hour = hour.toString().length == 1 ? "0" + hour.toString() : hour.toString();
  this.min = min.toString().length == 1 ? "0" + min.toString() : min.toString();
  this.smokingNumbers = number.toString();
  this.savingTime = savingHour.toString() + '時間' + savingMin.toString() + '分';
  this.savingMoney = (savingMoney + remSavingMoney).toString() + '円';
  timerCount(remSec, min, hour, day);
}

// タイマーのカウントを行う
Future<void> timerCount(int remSec, int min, int hour, int day) async {
  while(true) {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      // 一秒ごとに増加
      remSec++;
      if (remSec == 60) {
        // 一分ごとに秒をリセットし、分を増加
        remSec = 0;
        min++;
        if (min == 60) {
          //　一時間ごとに分をリセットし、時間を増加
          min = 0;
          hour++;
          if (hour == 24) {
            //　24時間ごとに時間をリセットし、日を増加
            hour = 0;
            day++;
            this.day = day.toString();
          }
          this.hour = hour.toString().length == 1 ? "0" + hour.toString() : hour.toString();
        }
        this.min = min.toString().length == 1 ? "0" + min.toString() : min.toString();

        // 本数（日数）
        int numberDay = smokingNumber * day;
        // 一時間当たりの本数
        double numberPerOneHour =  smokingNumber / 24;
        // 本数（時間）
        int numberHour = (numberPerOneHour * hour).truncate();
        // 節約した本数
        int number = numberDay + numberHour;

        // 一本当たりの時間
        final int smokingTime = 5;

        // 節約できた時間
        int savingTime = number * smokingTime;
        int savingHour = savingTime ~/ 60;
        int savingMin = savingTime % 60;

        // 節約した金額(箱数）
        int savingMoney =  (number ~/ 20) * boxValue;
        // 節約した金額(残り本数）
        int remSavingMoney = ((boxValue / 20) * (number % 20)).truncate() ;

        this.smokingNumbers = number.toString();
        this.savingTime = savingHour.toString() + '時間' + savingMin.toString() + '分';
        this.savingMoney = (savingMoney + remSavingMoney).toString() + '円';
      }
      sec =  remSec.toString().length == 1 ? "0" + remSec.toString() : remSec.toString();
    }
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Container(
              width: 350,
              // 縦幅
              height: 85,
              color: Colors.indigoAccent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Image.network(
                          'https://4.bp.blogspot.com/-Bu3khFKFeZ4/Uf8zrYCYL4I/AAAAAAAAWvE/_7M-Tv87a_E/s400/mezamashidokei.png'),
                    ),
                    Container(
                      width: 290,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Column(
                          children: [
                            Text(
                              '経過時間',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '$day日$hour:$min:$sec',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              width: 350,
              // 縦幅
              height: 85,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Image.network(
                          'https://2.bp.blogspot.com/-oDwavrWTeeo/WAhy4ctz82I/AAAAAAAA_IY/TYSatkgb5jcXa9vf1LeH2Ehdd5tI-2nQwCLcB/s400/tabako_suigara.png'),
                    ),
                    Container(
                      width: 290,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Column(
                          children: [
                            Text(
                              '禁煙できた本数',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '$smokingNumbers本',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              width: 350,
              // 縦幅
              height: 85,
              color: Colors.deepPurple,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Image.network(
                          'https://toyohira.kumin-c.jp/wp-content/uploads/sites/10/2018/09/kinshi_mark_tabako_kinen.png'),
                    ),
                    Container(
                      width: 290,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Column(
                          children: [
                            Text(
                              '節約できた時間',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '$savingTime',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              width: 350,
              // 縦幅
              height: 85,
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: Image.network(
                          'https://1.bp.blogspot.com/-KtVIPGzqFaU/VbnRnEF5z7I/AAAAAAAAwNo/WXdX-AlKG8I/s400/mark_yen_okaikei.png'),
                    ),
                    Container(
                      width: 290,
                      height: 85,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Column(
                          children: [
                            Text(
                              '節約できた金額',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '$savingMoney',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
