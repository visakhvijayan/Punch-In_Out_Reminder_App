import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:punch_in_reminder/services/local_notification_service.dart';
import 'package:punch_in_reminder/services/second_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';
import 'notifi_services.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'user_preferences.dart';
import 'package:punch_in_reminder/database.dart';
import 'past_activity_page.dart';
import 'dart:math';

class Homepage extends StatefulWidget {

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  late final LocalNotificationService service;
  @override
  void initState(){
    if (_isPunchedIn){
      startTimer();
    }
    super.initState();
    Workmanager().registerPeriodicTask(
      "taskTwo",
      "backup",
      frequency: Duration(minutes: 15),
    );

    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  bool _isPunchedIn = User_preferences.getpunchinflag();
  int _counter = User_preferences.getpunchinflag() ? max(User_preferences.getDutyhours()*60-(DateTime.now().difference(DateTime.parse(User_preferences.getPunchinToday())).inSeconds),0) : User_preferences.getDutyhours()*60;
  Timer? _timer;
  String? _punchInTime = DateFormat('hh:mm a').format(DateTime.parse(User_preferences.getPunchinToday()));


  void _incrementCounter() {
    setState(() {
      if (_isPunchedIn) {
        _isPunchedIn = false;

        User_preferences.setpunchinflag(false);
        User_preferences.setpunchoutflag(true);
        _timer?.cancel();
        _counter = User_preferences.getDutyhours()*60;
        int count = User_preferences.getWorkingDays();
        User_preferences.setWorkingDays(count+1);
        DateTime punchedinTime= DateTime.parse(User_preferences.getPunchinToday());
        int workingtime = User_preferences.getTotalWorkingTime();
        var diff = DateTime.now().difference(punchedinTime).inSeconds;
        User_preferences.setTotalWorkingTime(workingtime+diff);
        FlutterLocalNotificationsPlugin().cancelAll();
        // _counter = 28800;
      } else {

        _isPunchedIn = true;
        User_preferences.setpunchinflag(true);
        startTimer();
        User_preferences.savePunchinToday(DateTime.now());
        _punchInTime= DateFormat('hh:mm a').format(DateTime.parse(User_preferences.getPunchinToday()));

        if (!User_preferences.getDisable()){
          print(User_preferences.getDisable());
          NotificationService().delayNotification(title: 'PUNCH REMINDER', body: 'It is time to mark your punch out',seconds: (User_preferences.getDutyhours()*60));
        }



        if ((!User_preferences.getSnoozeOn())&&(!User_preferences.getDisable())){
          for(var i=8;i<13;i++){
            NotificationService().snoozeNotification(title: 'PUNCH REMINDER', body: 'It is time to mark your punch out',id: i, seconds: ((User_preferences.getDutyhours()*60)+(i-7)*User_preferences.getSnoozeinterval()*60));
          }
        }
      }
    });
  }

  String get timerString {
    Duration duration = Duration(seconds: _counter);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Card(
              elevation: 30,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(20.0)),
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.cyan[50],
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(
                      'Time left: $timerString',
                      style: TextStyle(
                          fontSize: 27,
                          fontFamily: 'Alkatra',
                          color: Color(0xFF408E91),
                      ),
                    ),
                    SizedBox(height: 20,),
                    if (_punchInTime != null)
                      Text(
                        'Last Punch In: $_punchInTime',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Alkatra',
                            color: Color(0xFF408E91)
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: (){
                      //     Workmanager().cancelByUniqueName("taskOne");
                      //   },
                      //     child:Text("Cancel Task"))
                  ],
                ),
              ),
            ),
            SizedBox(height: 60),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: !_isPunchedIn ? Color(0xFF1A5F7A) : Color(0xFFF263159), width: 5),
                shape: BoxShape.circle,
                color: !_isPunchedIn ? Color(0xFF159895) : Color(0xFFF495579),
              ),

              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) =>AlertDialog(
                      title: Text('Confirmation'),
                      content: Text('Are you sure you want to proceed?'),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(ctx).pop();
                          },
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () async{
                            Navigator.of(ctx).pop();
                            _incrementCounter();
                            if(_isPunchedIn)
                            {
                              await DB.insert(DateFormat('yyyy-MM-dd - hh:mm a ').format(DateTime.now()), 'Punch in');
                            }
                            else{
                              await DB.insert(DateFormat('yyyy-MM-dd - hh:mm a ').format(DateTime.now()), 'Punch out');
                            }
                          },
                          child: Text('YES'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.timer,
                  size: 30.0,
                  color: Colors.white,
                ),
                label: Text(
                  !_isPunchedIn ? 'Punch In' : 'Punch Out',
                  style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'Alkatra' ),
                ),
              ),
            ),
            SizedBox(height: 100),

            // ElevatedButton(
            //     onPressed: (){
            //       Workmanager().registerOneOffTask(
            //         "taskOne",
            //         "backup1",
            //         initialDelay: Duration(seconds: 5),
            //       );
            //     },
            //     child:Text("Run task"))

          ],
        ),
      ),
    );
  }
  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context as BuildContext,
          MaterialPageRoute(
              builder: ((context) => SecondScreen(payload: payload))));
    }
  }
}




