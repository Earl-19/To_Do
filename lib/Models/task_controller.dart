import 'package:get/get.dart';

import '../Database/flutter_native_timezone.dart';
import 'task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    var tasks = await DatabaseService().getTasks();
    taskList.assignAll(tasks.map((data) => Task.fromMap(data)).toList());
  }

  void addTask(Task task) async {
    await DatabaseService().insertTask(task.toMap());
    loadTasks();
  }

  void updateTask(Task task) async {
    await DatabaseService().updateTask(task.toMap());
    loadTasks();
  }

  void deleteTask(int id) async {
    await DatabaseService().deleteTask(id);
    loadTasks();
  }

  void archiveTask(Task task) async {
    task.isArchived = true;
    await DatabaseService().updateTask(task.toMap());
    loadTasks();
  }
}
