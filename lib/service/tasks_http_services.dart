import 'package:cloud_firestore/cloud_firestore.dart';

class TasksFireStoreServices {
  final _tasksCollections = FirebaseFirestore.instance.collection('todos');

  Stream<QuerySnapshot> getTasks() async* {
    yield* _tasksCollections.snapshots();
  }

  void addTasks(
      String title, String description, DateTime deadline, bool isDone) {
    _tasksCollections.add({
      "title" : title,
      "description" : description,
      "deadline" : deadline,
      "isDone" : false,
    });
  }

  void editTasks(
      String id, String title, String description, bool isDone) {
    _tasksCollections.doc(id).update({
      "title" : title,
      "description" : description,
      "isDone" : false,
    });
  }


  void deleteTask(String id) {
    _tasksCollections.doc(id).delete();
  }
}
