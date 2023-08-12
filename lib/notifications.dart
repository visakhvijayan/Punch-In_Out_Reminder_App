import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Reminder {
  final int id;
  final String title;
  final String description;
  final DateTime dateTime;

  Reminder({required this.id, required this.title, required this.description, required this.dateTime});
}

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Database _database;
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'reminder_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE reminders(id INTEGER PRIMARY KEY, title TEXT, description TEXT, dateTime TEXT)',
        );
      },
      version: 1,
    );

    _getReminders();
  }

  void _getReminders() async {
    // Insert some sample reminders if the database is empty
    if ((await _database.query('reminders')).isEmpty) {
      await _database.insert(
        'reminders',
        {
          'title': 'Missed PUNCH IN',
          'description': 'You missed a Punch in ',
          'dateTime': DateTime.now().add(Duration(hours: 2)).toString()

        },
      );

      await _database.insert(
        'reminders',
        {
          'title': 'Missed PUNCH OUT',
          'description': 'You missed a Punch out ',
          'dateTime': DateTime.now().add(Duration(hours: 2)).toString()

        },
      );

      await _database.insert(
        'reminders',
        {
          'title': 'Missed PUNCH IN',
          'description': 'You missed a Punch in ',
          'dateTime': DateTime.now().add(Duration(hours: 2)).toString()
        },
      );
    }

    // Retrieve all the reminders from the database
    final List<Map<String, dynamic>> maps = await _database.query('reminders');

    setState(() {
      _reminders = List.generate(
        maps.length,
            (i) {
          return Reminder(
            id: maps[i]['id'],
            title: maps[i]['title'],
            description: maps[i]['description'],
            dateTime: DateTime.parse(maps[i]['dateTime']),
          );
        },
      );
    });
  }


  void _deleteReminder(int id) async {
    await _database.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );

    setState(() {
      _reminders.removeWhere((reminder) => reminder.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Reminders'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: Center(
        child: _reminders.isEmpty
            ? Text(
          'No Reminders!',
          style: TextStyle(fontSize: 20),
        )
            : ListView.builder(
          itemCount: _reminders.length,
          itemBuilder: (context, index) {
            final reminder = _reminders[index];

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  reminder.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      reminder.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date & Time: ${reminder.dateTime.toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () => _deleteReminder(reminder.id),
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //TODO: Implement adding a reminder functionality
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.deepPurple,
      // ),
    );
  }
}
