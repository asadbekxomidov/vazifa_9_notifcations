// // import 'package:flutter/material.dart';
// // import 'package:vazifa_9_notifcations/service/local_notification_service.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

// //   Future<void> _selectTime(BuildContext context) async {
// //     final TimeOfDay? picked = await showTimePicker(
// //       context: context,
// //       initialTime: _selectedTime,
// //     );
// //     if (picked != null && picked != _selectedTime) {
// //       setState(() {
// //         _selectedTime = picked;
// //       });
// //       await LocalNotificationsService.scheduleDailyMotivationalQuote(
// //         _selectedTime.hour,
// //         _selectedTime.minute,
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.blue,
// //         title: const Text(
// //           "Home",
// //           style: TextStyle(
// //             fontSize: 22,
// //             fontWeight: FontWeight.w400,
// //             color: Colors.white,
// //           ),
// //         ),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               _selectTime(context);
// //             },
// //             icon: Icon(
// //               Icons.date_range,
// //               size: 25,
// //               color: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             if (!LocalNotificationsService.notificationsEnable)
// //               const Text("Xato"),
// //             TextButton(
// //                 onPressed: () {
// //                   LocalNotificationsService.showNotification();
// //                 },
// //                 child: const Text("Push")),
// //             TextButton(
// //                 onPressed: () {
// //                   LocalNotificationsService.showScheduledNotification();
// //                 },
// //                 child: const Text("Scheduled Push")),
// //             TextButton(
// //                 onPressed: () {
// //                   LocalNotificationsService.showPeriodicNotification();
// //                 },
// //                 child: const Text("Periodic Push")),
// //             Text(
// //               'Selected Time: ${_selectedTime.format(context)}',
// //               style: const TextStyle(fontSize: 16),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:vazifa_9_notifcations/service/local_notification_service.dart';
import 'package:vazifa_9_notifcations/views/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  int _selectedInterval = 2;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      await LocalNotificationsService.scheduleDailyMotivationalQuote(
        _selectedTime.hour,
        _selectedTime.minute,
      );
    }
  }

  Future<void> _schedulePomodoroNotification() async {
    await LocalNotificationsService.schedulePomodoroNotification(
        _selectedInterval);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _selectTime(context);
            },
            icon: Icon(
              Icons.date_range,
              size: 25,
              color: Colors.white,
            ),
          ),
          DropdownButton<int>(
            value: _selectedInterval,
            items: [1, 2, 3, 4, 5, 6].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  '$value hour${value > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade900,
                  ),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedInterval = newValue!;
              });
              _schedulePomodoroNotification();
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (!LocalNotificationsService.notificationsEnable)
            //   const Text("Xato"),
            TextButton(
                onPressed: () {
                  LocalNotificationsService.showNotification();
                },
                child: const Text("Push")),
            TextButton(
                onPressed: () {
                  LocalNotificationsService.showScheduledNotification();
                },
                child: const Text("Scheduled Push")),
            TextButton(
                onPressed: () {
                  LocalNotificationsService.showPeriodicNotification();
                },
                child: const Text("Periodic Push")),
            Text(
              'Selected Time: ${_selectedTime.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Pomodoro Interval (in hours):',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

