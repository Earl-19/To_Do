import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Models/task_controller.dart';
import 'add_task_screen.dart';
import 'archive_screen.dart';

class HomeScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App', style: GoogleFonts.lato()),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.squareCheck),
            onPressed: () {
              // Share functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              Get.to(ArchiveScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        final tasks =
            taskController.taskList.where((task) => !task.isArchived).toList();
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Dismissible(
              key: Key(task.id.toString()),
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: const Icon(Icons.archive, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  taskController.archiveTask(task);
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text(
                            'Are you sure you want to delete this task?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                }
                return false;
              },
              onDismissed: (direction) {
                taskController.deleteTask(task.id!);
              },
              child: ListTile(
                title: Text(task.title ?? ''),
                subtitle: Text(task.description ?? ''),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    task.isCompleted = value!;
                    taskController.updateTask(task);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddTaskScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
