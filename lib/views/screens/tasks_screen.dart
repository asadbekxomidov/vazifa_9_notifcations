import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vazifa_9_notifcations/controllers/tasks_controllers.dart';
import 'package:vazifa_9_notifcations/model/task.dart';
import 'package:vazifa_9_notifcations/views/widgets/custom_drawer.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksController = context.watch<TasksController>();

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Tasks',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add Task'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          tasksController.addTask(
                            titleController.text.trim(),
                            descriptionController.text.trim(),
                            DateTime.now(),
                            false,
                          );
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: Text('ADD'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('CANCEL'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: tasksController.list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text("No tasks available"),
            );
          }
          final tasks = snapshot.data!.docs;

          return tasks.isEmpty
              ? const Center(
                  child: Text('No tasks available'),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = Task.fromMap(tasks[index]);
                    return ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit Task'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController
                                      ..text = task.title,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                    ),
                                  ),
                                  TextField(
                                    controller: descriptionController
                                      ..text = task.description,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    tasksController.editTask(
                                      task.id,
                                      titleController.text.trim(),
                                      descriptionController.text.trim(),
                                      true,
                                      DateTime.now(),
                                    );
                                    titleController.clear();
                                    descriptionController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text('SAVE'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('CANCEL'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: IconButton(
                        onPressed: () {
                          tasksController.deleteTask(task.id);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
