import 'package:flutter/material.dart';
import 'package:flutter_dapp/screens/add_screen.dart';
import 'package:flutter_dapp/screens/fetch_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final List<Widget> _screens = [
    AddScreen(),
    FetchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(width: 2),
            Text('DApp'),
          ],
        ),
        elevation: 0,
      ),
      body: _screens[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          index = value;
        }),
        currentIndex: index,
        backgroundColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.black,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Fetch',
          ),
        ],
      ),
    );
  }
}
