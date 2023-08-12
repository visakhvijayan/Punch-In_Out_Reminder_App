import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_preferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setPunchintime(TimeOfDay _time) async {
    await _preferences.setString('punchin', _time.hour.toString()+":"+_time.minute.toString());
  }

  static String getPunchintime(){
    String? time = _preferences.getString('punchin');
    if (time==null){
      return '09:00';
    }
    else{
      return time;
    }
  }

  static Future setSnoozeinterval(int _interval) async {
    await _preferences.setInt('snooze', _interval);
  }

  static int getSnoozeinterval(){
    int? time = _preferences.getInt('snooze');
    if (time==null){
      return 5;
    }
    else{
      return time;
    }
  }



  static Future setDutyhours(int _interval) async {
    await _preferences.setInt('duty', _interval);
  }

  static int getDutyhours(){
    int? time = _preferences.getInt('duty');
    if (time==null){
      return 2;
    }
    else{
      return time;
    }
  }

  static Future setWorkingDays(int _count) async {
    await _preferences.setInt('workingdays', _count);
  }

  static int getWorkingDays(){
    int? time = _preferences.getInt('workingdays');
    if (time==null){
      return 0;
    }
    else{
      return time;
    }
  }

  static Future savePunchinToday(DateTime _time) async {
    await _preferences.setString('punchintoday', _time.toString());
  }

  static String getPunchinToday(){
    String? time = _preferences.getString('punchintoday');
    if (time==null){
      return DateTime.now().toString();
    }
    else{
      return time;
    }
  }

  static Future setTotalWorkingTime(int _count) async {
    await _preferences.setInt('workingtime', _count);
  }

  static int getTotalWorkingTime(){
    int? time = _preferences.getInt('workingtime');
    if (time==null){
      return 0;
    }
    else{
      return time;
    }
  }

  static Future setpunchinflag(bool val) async {
    await _preferences.setBool('ispunchedin', val);
  }

  static bool getpunchinflag(){
    bool? flag = _preferences.getBool('ispunchedin');
    if (flag==null){
      return false;
    }
    else{
      return flag;
    }
  }

  static Future setpunchoutflag(bool val) async {
    await _preferences.setBool('ispunchedout', val);
  }

  static bool getpunchoutflag(){
    bool? flag = _preferences.getBool('ispunchedout');
    if (flag==null){
      return false;
    }
    else{
      return flag;
    }
  }

  static Future setDisable(bool val) async {
    await _preferences.setBool('disable', val);
  }

  static bool getDisable(){
    bool? flag = _preferences.getBool('disable');
    if (flag==null){
      return false;
    }
    else{
      return flag;
    }
  }

  static Future setSnoozeOn(bool val) async {
    await _preferences.setBool('snoozeon', val);
  }

  static bool getSnoozeOn(){
    bool? flag = _preferences.getBool('snoozeon');
    if (flag==null){
      return true;
    }
    else{
      return flag;
    }
  }

}
