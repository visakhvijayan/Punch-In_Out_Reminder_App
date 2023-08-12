import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notifi_services.dart';
import 'user_preferences.dart';


class Settingspage extends StatefulWidget {

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {

  late TimeOfDay picked;
  int? snoozevalue = User_preferences.getSnoozeinterval();
  int? workhourvalue = User_preferences.getDutyhours();

  void setnot(){
    NotificationService().showNotification(title: 'Punch in', body: 'Set by the android alarm settings');
  }

  void selectinTime(BuildContext context) async {
    String _time = await User_preferences.getPunchintime();
    int hour = await int.parse(_time.split(":")[0]);
    int minute = await int.parse(_time.split(":")[1]);
    picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    ))!;
    setState(() {
      if (picked!=null) {
        NotificationService().scheduleNotification(
            title : 'PUNCH REMINDER',
            body: 'It is a new day at work, let us punch-in to start',
            scheduledNotificationDateTime: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,picked.hour,picked.minute));
        print(picked.hour.toString()+' '+picked.minute.toString());
        if ((!User_preferences.getSnoozeOn())&&(!User_preferences.getDisable())){
          for(var i=3;i<8;i++){
            NotificationService().scheduleNotification(id : i, scheduledNotificationDateTime: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,picked.hour,picked.minute).add(Duration(minutes: (User_preferences.getSnoozeinterval()*(i-2)))), title: 'PUNCH REMINDER', body: 'It is time to mark your punch in',);
          }
        }
        User_preferences.setPunchintime(picked);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(
              fontFamily: 'Alkatra',
            )),
        backgroundColor: Color(0xFF1A5F7A),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(' Reminder Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              alignment: Alignment.bottomLeft,
            ),
            onPressed: () {
              selectinTime(context);  // changing punchin reminder timings
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 26,bottom: 26,),
              child: Text('Punch in Reminder Time',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            height: 5,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Snooze Interval", style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  ),
                  DropdownButton(
                    value: snoozevalue,
                    items: [
                      DropdownMenuItem(child: Text("1 minute"), value: 1,),
                      DropdownMenuItem(child: Text("2 minutes"), value: 2,),
                      DropdownMenuItem(child: Text("3 minute"), value: 3,),
                      DropdownMenuItem(child: Text("5 minute"), value: 5,),
                      DropdownMenuItem(child: Text("7 minute"), value: 7,),
                      DropdownMenuItem(child: Text("10 minute"), value: 10,),
                    ],
                    onChanged: (int? newvalue){
                      setState(() {
                        if (newvalue!= null) {
                          User_preferences.setSnoozeinterval(newvalue);
                          snoozevalue = newvalue;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Duty hours", style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  ),
                  DropdownButton(
                    value: workhourvalue,
                    items: [
                      DropdownMenuItem(child: Text("1 minute"), value: 1,),
                      DropdownMenuItem(child: Text("2 minute"), value: 2,),
                      DropdownMenuItem(child: Text("3 minute"), value: 3,),
                      DropdownMenuItem(child: Text("4 minute"), value: 4,),
                      DropdownMenuItem(child: Text("5 minute"), value: 5,),
                    ],
                    onChanged: (int? newvalue){
                      setState(() {
                        if (newvalue!= null) {
                          User_preferences.setDutyhours(newvalue);
                          workhourvalue = newvalue;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            height: 5,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              alignment: Alignment.bottomLeft,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) =>AlertDialog(
                  title: Text('Reset Settings'),
                  content: Text('Do you want to reset reminder timings?'),
                  actions: [
                    TextButton(
                      onPressed: (){
                        Navigator.of(ctx).pop();
                      },
                      child: Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          User_preferences.setPunchintime(TimeOfDay(hour: 9, minute: 00));
                          User_preferences.setSnoozeinterval(5);
                          User_preferences.setDutyhours(2);
                          workhourvalue=2;
                          snoozevalue=5;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text('RESET'),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 26,bottom: 26,),
              child: Text('Reset Settings',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
            indent: 10,
            endIndent: 10,
            height: 5,
          ),
          SizedBox(
            height: 20.0,
          ),
          SwitchScreen(),
          SnoozeScreen(),
        ],
      ),
    );
  }
}

class SwitchScreen extends StatefulWidget {

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool isSwitched = User_preferences.getDisable();
  var textValue = 'Disable reminders';
  void toggleSwitch(bool value) {
    if(isSwitched == false)
    {
      User_preferences.setDisable(true);
      setState(() {
        isSwitched = true;
      }
      );
    }
    else
    {
      User_preferences.setDisable(false);
      setState(() {
        isSwitched = false;
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('$textValue', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Transform.scale(
            scale: 1.2,
            child: Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.green[800],
              activeTrackColor: Colors.green[400],
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
            )
        ),
      ],
    );
  }
}

class SnoozeScreen extends StatefulWidget {
  const SnoozeScreen({Key? key}) : super(key: key);

  @override
  State<SnoozeScreen> createState() => _SnoozeScreenState();
}

class _SnoozeScreenState extends State<SnoozeScreen> {
  bool isSwitched = User_preferences.getSnoozeOn();
  void toggleSwitch(bool value) {
    if(isSwitched == false)
    {
      User_preferences.setSnoozeOn(true);
      for(var i=3;i<13;i++){
        FlutterLocalNotificationsPlugin().cancel(i);
      }
      setState(() {
        isSwitched = true;
      }
      );
    }
    else
    {
      User_preferences.setSnoozeOn(false);
      setState(() {
        isSwitched = false;
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Disable Snooze', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Transform.scale(
            scale: 1.2,
            child: Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.green[800],
              activeTrackColor: Colors.green[400],
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
            )
        ),
      ],
    );
  }
}



