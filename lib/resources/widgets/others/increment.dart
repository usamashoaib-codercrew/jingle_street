import 'package:flutter/material.dart';

class MyListView extends StatefulWidget {
  const MyListView({Key? key}) : super(key: key);

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<int> _counters = List.generate(10, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView with Counters'),
      ),
      body: ListView.builder(
        itemCount: _counters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
            subtitle: Text('Count: ${_counters[index]}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _counters[index]++;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _counters[index]--;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
