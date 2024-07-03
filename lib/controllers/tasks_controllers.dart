import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vazifa_9_notifcations/model/task.dart';
import 'package:vazifa_9_notifcations/service/tasks_http_services.dart';
import 'package:vazifa_9_notifcations/service/local_notification_service.dart'; // Import your notification service

class TasksController extends ChangeNotifier {
  final _tasksFireStoreServices = TasksFireStoreServices();

  Stream<QuerySnapshot> get list {
    return _tasksFireStoreServices.getTasks();
  }

  void addTask(
      String title, String description, DateTime deadline, bool isDone) async {
    _tasksFireStoreServices.addTasks(title, description, deadline, isDone);
  }

  // void editTasks(String id, String title, String description, bool isDone) async {
  //   _tasksFireStoreServices.editTasks(id, title, description, isDone);

  //   // if (isDone) {
  //   //   // Show a notification when the task is marked as done
  //   //   await LocalNotificationsService.showTaskDoneNotification();
  //   // }

  //   if (isDone) {
  //     final task = Task(id: id, title: title, description: description);
  //     await LocalNotificationsService.showTaskDoneNotification(task);
  //   }
  // }

  void editTask(String id, String title, String description, bool isDone,
      DateTime deadline) async {
    _tasksFireStoreServices.editTasks(id, title, description, isDone);

    if (isDone) {
      final task = Task(
        id: id,
        title: title,
        description: description,
        isDone: isDone,
        deadline: deadline,
      );
      await LocalNotificationsService.showTaskDoneNotification(task);
    }
  }

  void deleteTask(String id) {
    _tasksFireStoreServices.deleteTask(id);
  }
}
