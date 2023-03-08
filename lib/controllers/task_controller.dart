import 'package:cool_todo/models/task.dart';
import 'package:cool_todo/services/db.dart';
import 'package:cool_todo/services/notifications.dart';
import 'package:cool_todo/services/utils.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTasks(date: Utils.dateToString(date: DateTime.now()));
  }

  List<Task> allTasks = <Task>[].obs;
  List<Task> tasks = <Task>[].obs;

  void getTasks({required String date}) async {
    List<Map<String, dynamic>> tasks = await DB.selectTasksByDate(date: date);
    Iterable<Task> tsks = tasks.map((task) => Task.fromMap(task));
    for (Task tsk in tsks) {
      if ((Utils.stringToTime(date: tsk.date, time: tsk.endTime)
              .isBefore(DateTime.now())) ||
          (Utils.stringToDate(date: tsk.date).month <= DateTime.now().month &&
              Utils.stringToDate(date: tsk.date).day < DateTime.now().day)) {
        await setDeserted(task: tsk);
      }
    }
    allTasks.assignAll(tsks);
    getAllTasks();
  }

  Future<Task> getTaskByID({required int id}) async {
    Map<String, dynamic> task = await DB.selectTaskByID(id: id);
    return Task.fromMap(task);
  }

  Future<void> getAllTasks() async {
    List<Map<String, dynamic>> futureTasks = await DB.selectTasks();
    Iterable<Task> tsks = futureTasks.map((task) => Task.fromMap(task));
    for (Task tsk in tsks) {
      if ((Utils.stringToTime(date: tsk.date, time: tsk.endTime)
              .isBefore(DateTime.now())) ||
          (Utils.stringToDate(date: tsk.date).month <= DateTime.now().month &&
              Utils.stringToDate(date: tsk.date).day < DateTime.now().day)) {
        await setDeserted(task: tsk);
      }
    }
    tasks.assignAll(tsks);
  }

  Future<int> addTask({required Task task}) async =>
      await DB.insertTask(task: task);

  Future<void> deleteTask({required Task task}) async {
    DB.deleteTask(task: task);
    Notifications().cancelNotificationWithID(id: task.id!);
  }

  Future<void> setCompleted({required Task task}) async {
    DB.setCompleted(task: task);
    // getTasks(date: Utils.dateToString(date: DateTime.now()));
    Notifications().cancelNotificationWithID(id: task.id!);
  }

  Future<void> setDeserted({required Task task}) async {
    DB.setDeserted(task: task);
    // getTasks(date: Utils.dateToString(date: DateTime.now()));
    Notifications().cancelNotificationWithID(id: task.id!);
  }
}
