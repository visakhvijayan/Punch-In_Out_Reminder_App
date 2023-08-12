import 'package:flutter/material.dart';
import 'user_preferences.dart';
import 'past_activity_page.dart';
import 'package:punch_in_reminder/database.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {

  int totaltime = User_preferences.getTotalWorkingTime();
  int totaldays = User_preferences.getWorkingDays();
  int avghour = User_preferences.getWorkingDays()==0 ? 0 : User_preferences.getTotalWorkingTime()~/User_preferences.getWorkingDays();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            Card(
              elevation: 30,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.cyan[50],
              child: Padding(
                padding: const EdgeInsets.only(top: 26,bottom: 26,left: 10),
                child: Text("No of marked days : " + totaldays.toString(),
                  style: TextStyle(
                    fontFamily: 'Alkatra',
                    color: Color(0xFF408E91),
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 30,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.cyan[50],
              child: Padding(
                padding: const EdgeInsets.only(top: 26,bottom: 26,left: 10),
                child: Text(
                  "Average working time : " + avghour.toString() + " seconds",
                  style: TextStyle(
                    fontFamily: 'Alkatra',
                    color: Color(0xFF408E91),
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A5F7A),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PastActivityPage()),
                    );
                  }, child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("PAST ACTIVITY",
                    style: TextStyle(
                    fontFamily: 'Alkatra',
                      fontSize: 15,
                )
                ),
              )),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1A5F7A),
                  ),
                  onPressed: (){
                    setState(() {
                      showDialog(
                        context: context,
                        builder: (ctx) =>AlertDialog(
                          title: Text
                            ('Clear details',
                              style: TextStyle(
                                fontFamily: 'Alkatra',
                              )
                          ),
                          content: Text('Do you want to clear the data?',
                              style: TextStyle(
                                fontFamily: 'Alkatra',
                              )
                          ),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(ctx).pop();
                              },
                              child: Text('CANCEL',
                                  style: TextStyle(
                                    fontFamily: 'Alkatra',
                                  )
                              ),
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  User_preferences.setTotalWorkingTime(0);
                                  User_preferences.setWorkingDays(0);
                                  avghour=0;
                                  totaldays=0;
                                });
                                Navigator.of(ctx).pop();
                              },
                              child: Text('CLEAR',
                                  style: TextStyle(
                                    fontFamily: 'Alkatra',
                                  )
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    );
                  }, child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("CLEAR ALL",
                    style: TextStyle(
                      fontFamily: 'Alkatra',
                      fontSize: 15,
                    )
                ),
              )),
            ),
          ],
        )
    );
  }
}
