import 'package:flutter/material.dart';
import 'package:punch_in_reminder/database.dart';

class PastActivityPage extends StatefulWidget {
  @override
  _PastActivityPageState createState() => _PastActivityPageState();
}

class _PastActivityPageState extends State<PastActivityPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = DB.queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Activity'),
        backgroundColor: Color(0xFF1A5F7A),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index]['type']),
                  subtitle: Text(snapshot.data![index]['date']),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
