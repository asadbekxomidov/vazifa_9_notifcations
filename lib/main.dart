import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vazifa_9_notifcations/controllers/tasks_controllers.dart';
import 'package:vazifa_9_notifcations/views/screens/tasks_screen.dart';
import 'package:vazifa_9_notifcations/service/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationsService.requestPermission();
  await LocalNotificationsService.start();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TasksController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TasksScreen(),
    );
  }
}



/*




import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vazifa_9_notifcations/service/local_notification_service.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationsService.requestPermission();
  await LocalNotificationsService.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
*/