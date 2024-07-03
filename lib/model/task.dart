import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime deadline;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isDone,
  });

  factory Task.fromMap(QueryDocumentSnapshot  query) {
    return Task(
      id: query.id,
      title: query['title'],
      description: query['description'],
      deadline: (query['deadline'] as Timestamp).toDate(),
      isDone: query['isDone'],
    );
  }
}
