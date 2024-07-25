import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/task_controller.dart';

class ArchiveScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Tasks', style: GoogleFonts.lato()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        final archivedTasks =
            taskController.taskList.where((task) => task.isArchived).toList();
        return ListView.builder(
          itemCount: archivedTasks.length,
          itemBuilder: (context, index) {
            final task = archivedTasks[index];
            return Dismissible(
              key: Key(task.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm'),
                      content:
                          Text('Are you sure you want to delete this task?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
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
    );
  }
}
