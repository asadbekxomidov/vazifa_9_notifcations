import 'package:flutter/material.dart';
import 'package:vazifa_9_notifcations/views/screens/home_screen.dart';
import 'package:vazifa_9_notifcations/views/screens/tasks_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue,
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.home,
                  size: 25,
                  color: Colors.black,
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => HomeScreen()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.task,
                  size: 25,
                  color: Colors.black,
                ),
                title: Text('Tasks'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => TasksScreen()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
