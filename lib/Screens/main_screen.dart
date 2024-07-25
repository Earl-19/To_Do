import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/task_controller.dart';
import 'add_task_screen.dart';
import 'archive_screen.dart';
import 'custom_date_timeline.dart';

class MainScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artem\'s todos', style: GoogleFonts.lato()),
        actions: [
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: () {
              Get.to(ArchiveScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CustomDateTimeline(
            initialDate: DateTime.now(),
            onDateSelected: (date) {
              // Filter tasks by selected date
            },
          ),
          Expanded(
            child: Obx(() {
              final tasks = taskController.taskList
                  .where((task) => !task.isArchived)
                  .toList();
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key(task.id.toString()),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.archive, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
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
                              title: Text('Confirm'),
                              content: Text(
                                  'Are you sure you want to delete this task?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text('Delete'),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddTaskScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
