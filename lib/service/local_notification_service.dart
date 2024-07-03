// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:http/http.dart' as http;
// import 'package:timezone/data/latest_all.dart' as tzl;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:vazifa_9_notifcations/model/task.dart';

// class LocalNotificationsService {
//   static final _localNotification = FlutterLocalNotificationsPlugin();

//   static bool notificationsEnable = false;
  

//   static Future<void> requestPermission() async {
//     if (Platform.isIOS || Platform.isMacOS) {
//       notificationsEnable = await _localNotification
//               .resolvePlatformSpecificImplementation<
//                   IOSFlutterLocalNotificationsPlugin>()
//               ?.requestPermissions(alert: true, badge: true, sound: true) ??
//           false;

//       await _localNotification
//           .resolvePlatformSpecificImplementation<
//               MacOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(alert: true, badge: true, sound: true);
//     } else if (Platform.isAndroid) {
//       final androidImplementation =
//           _localNotification.resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>();

//       final bool? grantedNotificationPermission =
//           await androidImplementation?.requestNotificationsPermission();

//       final bool? grantedScheduledNotificationPermission =
//           await androidImplementation?.requestExactAlarmsPermission();

//       notificationsEnable = grantedNotificationPermission ?? false;
//       notificationsEnable = grantedScheduledNotificationPermission ?? false;
//     }
//   }

//   static Future<void> start() async {
//     final currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     tzl.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));

//     const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
//     final iosInit = DarwinInitializationSettings(
//       notificationCategories: [
//         DarwinNotificationCategory(
//           'demoCategory',
//           actions: <DarwinNotificationAction>[
//             DarwinNotificationAction.plain('id_1', 'Action 1'),
//             DarwinNotificationAction.plain(
//               'id_2',
//               'Action 2',
//               options: <DarwinNotificationActionOption>{
//                 DarwinNotificationActionOption.destructive,
//               },
//             ),
//             DarwinNotificationAction.plain(
//               'id_3',
//               'Action 3',
//               options: <DarwinNotificationActionOption>{
//                 DarwinNotificationActionOption.foreground,
//               },
//             ),
//           ],
//           options: <DarwinNotificationCategoryOption>{
//             DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//           },
//         )
//       ],
//     );

//     final notificationInit = InitializationSettings(
//       android: androidInit,
//       iOS: iosInit,
//     );

//     await _localNotification.initialize(notificationInit);
//   }

//   static Future<List<dynamic>> fetchQuotes() async {
//     final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load quotes');
//     }
//   }

//   static Future<void> scheduleDailyMotivationalQuote(int hour, int minute) async {
//     final quotes = await fetchQuotes();
//     final randomQuote = (quotes..shuffle()).first;
//     final quoteText = randomQuote['text'];

//     const androidDetails = AndroidNotificationDetails(
//       "motivationChannelId",
//       "motivationChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.aiff",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.zonedSchedule(
//       0,
//       "Daily Motivation",
//       quoteText,
//       _nextInstanceOf(hour, minute),
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }

//   static void showNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       "goodChannelId",
//       "goodChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//       actions: [
//         AndroidNotificationAction('id_1', 'Action 1'),
//         AndroidNotificationAction('id_2', 'Action 2'),
//         AndroidNotificationAction('id_3', 'Action 3'),
//       ],
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.mp3",
//       categoryIdentifier: "demoCategory",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.show(
//       0,
//       "Birinchi NOTIFICATION",
//       "Salom sizga \$1,000,000 pul tushdi. SMS kodni qayta yuboring!",
//       notificationDetails,
//     );
//   }

//   static void showScheduledNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       "goodChannelId",
//       "goodChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//       ticker: "Ticker",
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.aiff",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.zonedSchedule(
//       0,
//       "Birinchi NOTIFICATION",
//       "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: "Salom",
//     );
//   }

//   static void showPeriodicNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       "goodChannelId",
//       "goodChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//       ticker: "Ticker",
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.aiff",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.periodicallyShow(
//       0,
//       "Birinchi NOTIFICATION",
//       "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
//       RepeatInterval.everyMinute,
//       notificationDetails,
//       payload: "Salom",
//     );
//   }


//   static Future<void> schedulePomodoroNotification(int intervalInHours) async {
//     const androidDetails = AndroidNotificationDetails(
//       "pomodoroChannelId",
//       "pomodoroChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.aiff",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.periodicallyShow(
//       1,
//       "Pomodoro Break",
//       "Time to take a break!",
//       RepeatInterval.hourly,
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       payload: "Time to take a break",
//     );

//     final intervalDuration = Duration(hours: intervalInHours);
//     await _localNotification.zonedSchedule(
//       2,
//       "Pomodoro Break",
//       "Time to take a break!",
//       tz.TZDateTime.now(tz.local).add(intervalDuration),
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }


//   static Future<void> scheduleTaskReminder(Task task) async {
//     const androidDetails = AndroidNotificationDetails(
//       "taskReminderChannelId",
//       "taskReminderChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.aiff",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.zonedSchedule(
//       task.id.hashCode,
//       "Task Reminder",
//       "Reminder for task: ${task.title}",
//       tz.TZDateTime.from(task.deadline, tz.local),
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   static Future<void> notifyTaskCompleted(Task task) async {
//     const androidDetails = AndroidNotificationDetails(
//       "taskCompletedChannelId",
//       "taskCompletedChannelName",
//       importance: Importance.max,
//       priority: Priority.max,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("notification"),
//     );

//     const iosDetails = DarwinNotificationDetails(
//       sound: "notification.aiff",
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotification.show(
//       task.id.hashCode,
//       "Task Completed",
//       "Task: ${task.title} has been completed",
//       notificationDetails,
//       payload: "Task: ${task.title} has been completed",
//     );
//   }

// }






// ignore_for_file: dead_code

/*




import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'task.dart';

class LocalNotificationsService {
  static final _localNotification = FlutterLocalNotificationsPlugin();
  static bool notificationsEnable = false;

  static Future<void> requestPermission() async {
    // Your existing requestPermission code
  }

  static Future<void> start() async {
    // Your existing start code
  }

  static Future<void> scheduleTaskReminder(Task task) async {
    const androidDetails = AndroidNotificationDetails(
      "taskReminderChannelId",
      "taskReminderChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.zonedSchedule(
      task.id.hashCode,
      "Task Reminder",
      "Reminder for task: ${task.title}",
      tz.TZDateTime.from(task.deadline, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> notifyTaskCompleted(Task task) async {
    const androidDetails = AndroidNotificationDetails(
      "taskCompletedChannelId",
      "taskCompletedChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.show(
      task.id.hashCode,
      "Task Completed",
      "Task: ${task.title} has been completed",
      notificationDetails,
      payload: "Task: ${task.title} has been completed",
    );
  }
}

















  static Future<void> scheduleDailyMotivationalQuote(int hour, int minute) async {
    const androidDetails = AndroidNotificationDetails(
      "motivationChannelId",
      "motivationChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
    if (response.statusCode == 200) {
      List quotes = json.decode(response.body);
      String randomQuote = (quotes..shuffle()).first['text'];

      await _localNotification.zonedSchedule(
        0,
        "Daily Motivation",
        randomQuote,
        _nextInstanceOfTime(hour, minute),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

*/



import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;
import 'package:vazifa_9_notifcations/model/task.dart';

class LocalNotificationsService {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationsEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      notificationsEnabled = await _localNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;

      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final androidImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      notificationsEnabled =
          grantedNotificationPermission ?? false && grantedScheduledNotificationPermission! ?? false;
    }
  }

  static Future<void> start() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );

    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotification.initialize(notificationInit);
  }

  static Future<List<dynamic>> fetchQuotes() async {
    final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load quotes');
    }
  }

  static Future<void> scheduleDailyMotivationalQuote(int hour, int minute) async {
    final quotes = await fetchQuotes();
    final randomQuote = (quotes..shuffle()).first;
    final quoteText = randomQuote['text'];

    const androidDetails = AndroidNotificationDetails(
      "motivationChannelId",
      "motivationChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.zonedSchedule(
      0,
      "Daily Motivation",
      quoteText,
      _nextInstanceOf(hour, minute),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static void showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      actions: [
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
        AndroidNotificationAction('id_3', 'Action 3'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.mp3",
      categoryIdentifier: "demoCategory",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.show(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni qayta yuboring!",
      notificationDetails,
    );
  }

  static void showScheduledNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.zonedSchedule(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Salom",
    );
  }

  static void showPeriodicNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.periodicallyShow(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: "Salom",
    );
  }

  static Future<void> schedulePomodoroNotification(int intervalInHours) async {
    const androidDetails = AndroidNotificationDetails(
      "pomodoroChannelId",
      "pomodoroChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.periodicallyShow(
      1,
      "Pomodoro Break",
      "Time to take a break!",
      RepeatInterval.hourly,
      notificationDetails,
      androidAllowWhileIdle: true,
      payload: "Time to take a break",
    );

    final intervalDuration = Duration(hours: intervalInHours);
    await _localNotification.zonedSchedule(
      2,
      "Pomodoro Break",
      "Time to take a break!",
      tz.TZDateTime.now(tz.local).add(intervalDuration),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleTaskReminder(Task task) async {
    const androidDetails = AndroidNotificationDetails(
      "taskReminderChannelId",
      "taskReminderChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.zonedSchedule(
      task.id.hashCode,
      "Task Reminder",
      "Reminder for task: ${task.title}",
      tz.TZDateTime.from(task.deadline, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> notifyTaskCompleted(Task task) async {
    const androidDetails = AndroidNotificationDetails(
      "taskCompletedChannelId",
      "taskCompletedChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.show(
      task.id.hashCode,
      "Task Completed",
      "Task: ${task.title} has been completed",
      notificationDetails,
      payload: "Task: ${task.title} has been completed",
    );
  }

  static Future<void> showTaskDoneNotification(Task task) async {
    const androidDetails = AndroidNotificationDetails(
      "taskDoneChannelId",
      "taskDoneChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.show(
      task.id.hashCode,
      "Task Completed",
      "Task: ${task.title} has been marked as done",
      notificationDetails,
      payload: "Task: ${task.title} has been marked as done",
    );
  }
}
