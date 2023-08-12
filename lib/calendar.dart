import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  Database? _database;
  List<DateTime> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calendar.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS selected_dates (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT)',
        );
      },
    );

    final List<Map<String, dynamic>> data =
    await _database!.query('selected_dates');

    setState(() {
      _selectedDates = data.map((e) => DateTime.parse(e['date'])).toList();
    });
  }

  Future<void> _toggleDate(DateTime date) async {
    if (_selectedDates.contains(date)) {
      await _database!.delete(
        'selected_dates',
        where: 'date = ?',
        whereArgs: [DateFormat('yyyy-MM-dd').format(date)],
      );
      setState(() {
        _selectedDates.remove(date);
      });
    } else {
      await _database!.insert(
        'selected_dates',
        {'date': DateFormat('yyyy-MM-dd').format(date)},
      );
      setState(() {
        _selectedDates.add(date);
      });
    }
  }

  bool _isSelected(DateTime date) => _selectedDates.contains(date);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth =
        DateTime(now.year, now.month, 0).day; // Calculate days in month
    final firstDayOfMonth =
        DateTime(now.year, now.month, 1).weekday - DateTime.monday;
    final itemCount = daysInMonth + firstDayOfMonth - 1; // Calculate item count
    final monthName = DateFormat('MMMM yyyy').format(now);

    final dayNames = [      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar App'),
        backgroundColor: Color(0xFF1A5F7A),
      ),
      body: Column(
        children: [
          Row(
            children: dayNames.map((dayName) => Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  dayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )).toList(),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) {
                final dayOfMonth = index - firstDayOfMonth + 1;
                final date = DateTime(now.year, now.month, dayOfMonth);
                final isToday = date.isAtSameMomentAs(DateTime.now());

                if (dayOfMonth <= 0 || dayOfMonth > daysInMonth + 7) {
                  return Container();
                }

                return GestureDetector(
                  onTap: () => _toggleDate(date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isSelected(date) ? Color(0xFF93bfcf)
                          : isToday ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        '$dayOfMonth',
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: itemCount, // Use calculated item count
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            monthName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}