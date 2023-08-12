import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:punch_in_reminder/user_preferences.dart';
import 'notifi_services.dart';
import 'homepage.dart';
import 'activity.dart';
import 'notifications.dart';
import 'settings.dart';
import 'calendar.dart';
import 'package:workmanager/workmanager.dart';
import 'package:punch_in_reminder/database.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await User_preferences.init();
  await DB.init();
  NotificationService().initNotification();
  Workmanager().initialize(callbackDispatcher,);
  Workmanager().registerPeriodicTask("3", "SimplePeriodictask", frequency: Duration(minutes: 15));
  tz.initializeTimeZones();
  // await scheduleAlarm();
  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    TimeOfDay now = TimeOfDay.now();
    NotificationService().showNotification(title: 'Notification Schedule', body: 'Punchin scheduled by new work manager');
    NotificationService().delayNotification(title: 'Testing workmanager', body: 'This notification came after 60 seconds of first notification',seconds: 60);

    if (now.hour > 3 || (now.hour == 3 && now.minute >= 30)) {
      if (now.hour < 4 || (now.hour == 4 && now.minute < 31)) {
        if (!User_preferences.getDisable()){
          User_preferences.setpunchinflag(false);
          User_preferences.setpunchoutflag(false);
          // String time = await User_preferences.getPunchintime();
          // int hour = await int.parse(time.split(":")[0]);
          // // int minute = await int.parse(time.split(":")[1]);
          // NotificationService().scheduleNotification(
          //     title : 'Punch in',
          //     body: 'Your Punch in for today is pending!',
          //     scheduledNotificationDateTime: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,hour,minute));
          if (!User_preferences.getSnoozeOn()){
            for(var i=3;i<8;i++){
              NotificationService().snoozeNotification(id: i, seconds: ((User_preferences.getDutyhours()*60)+(i-2)*User_preferences.getSnoozeinterval()*60));
            }
          }
        }
      }
    }

    if (now.hour > 10 || (now.hour == 10 && now.minute >= 30)) {
      if (now.hour < 11 || (now.hour == 11 && now.minute < 31)) {
        if (User_preferences.getpunchoutflag()==false){
          if ( User_preferences.getpunchinflag()==false){
            NotificationService().showNotification(title: 'Punch missed', body: 'We think you have missed your punch today!');
          }
        }
      }
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
          builder: (context) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                        'Punch Reminder',
                    style: TextStyle(
                      fontFamily: 'Alkatra',
                      fontSize: 22,
                    ),
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF93bfcf) , Color(0xFF146c94)],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  // elevation: 20,
                  // shadowColor: Colors.grey,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settingspage()));
                    },
                    icon: Icon(Icons.settings_suggest_outlined,
                      size: 35,),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calendar()));
                        },
                        icon: Icon(Icons.calendar_month_sharp)),
                  ],
                  bottom: TabBar(
                      indicatorColor: Colors.white,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(icon: Icon(Icons.home),),
                        Tab(icon: Icon(Icons.edit_notifications_outlined),),
                        Tab(icon: Icon(Icons.analytics_outlined),),
                      ]),
                ),
                body: TabBarView(
                    children: [
                      Homepage(),
                      Notifications(),
                      Activity(),
                    ]
                ),
              ),
            );
          }
      ),
    );
  }
}