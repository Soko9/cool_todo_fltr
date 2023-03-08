import 'package:cool_todo/controllers/task_controller.dart';
import 'package:cool_todo/models/task.dart';
import 'package:cool_todo/services/utils.dart';
import 'package:cool_todo/views/screens/add_task_screen.dart';
import 'package:cool_todo/services/notifications.dart';
import 'package:cool_todo/views/palette/styles.dart';
import 'package:cool_todo/views/palette/themes.dart';
import 'package:cool_todo/views/widgets/t_button.dart';
import 'package:cool_todo/views/widgets/t_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController _taskController = Get.put(TaskController());
  late final Notifications notifications;
  DateTime _selectedDate = DateTime.now();

  void _showBottomSheet(BuildContext context, Task task) => showBottomSheet(
        context: context,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        builder: (context) => Container(
          margin: const EdgeInsets.all(24.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          color: Colors.transparent,
          child: bottomSheet(context, task),
        ),
      );

  void _showAllTasksSheet(BuildContext context) => showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor:
            context.theme.scaffoldBackgroundColor.withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        builder: (context) => Container(
          margin: const EdgeInsets.all(24.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: allTasksList(context),
        ),
      );

  @override
  void initState() {
    super.initState();
    notifications = Notifications();
    notifications.initializeNotification();
    notifications.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          addTaskHeader(context),
          datePicker(context),
          taskList(),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Themes().swithTheme();
        },
        child: RotatedBox(
          quarterTurns: 2,
          child: IconTheme(
            data: Theme.of(context).iconTheme,
            child: Icon(
              Themes().getThemeMode()
                  ? Icons.lightbulb_outline
                  : Icons.lightbulb,
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            _taskController.getTasks(
                date: Utils.dateToString(date: _selectedDate));
            _showAllTasksSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconTheme(
              data: Theme.of(context).iconTheme,
              child: const Icon(
                Icons.all_inbox_rounded,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding addTaskHeader(BuildContext context) {
    return Padding(
      padding: Styles.defaultPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: Styles.lightTextStyle(
                  size: 22.0,
                  color: context.theme.dialogBackgroundColor,
                ),
              ),
              Text(
                "Today",
                style: Styles.boldTextStyle(
                  size: 32.0,
                  color: context.theme.backgroundColor,
                ),
              ),
            ],
          ),
          TButton(
            ontap: () async {
              await Get.to(
                () => const AddTaskScreen(),
                curve: Curves.fastOutSlowIn,
                duration: const Duration(seconds: 1),
                transition: Transition.cupertino,
              );
              _taskController.getTasks(
                  date: Utils.dateToString(date: _selectedDate));
            },
            label: "Add Task",
          ),
        ],
      ),
    );
  }

  Padding datePicker(BuildContext context) {
    return Padding(
      padding: Styles.defaultPadding,
      child: DatePicker(
        DateTime.now(),
        width: 80.0,
        height: 120.0,
        initialSelectedDate: _selectedDate,
        selectionColor: Themes.primaryColor,
        selectedTextColor: Themes.darkBack,
        dateTextStyle: Styles.boldTextStyle(
          size: 26.0,
          color: context.theme.errorColor,
        ),
        dayTextStyle: Styles.regularTextStyle(
          size: 12.0,
          color: context.theme.errorColor,
        ),
        monthTextStyle: Styles.regularTextStyle(
          size: 12.0,
          color: context.theme.errorColor,
        ),
        onDateChange: (selectedDate) {
          setState(() => _selectedDate = selectedDate);
          _taskController.getTasks(
              date: Utils.dateToString(date: _selectedDate));
        },
      ),
    );
  }

  Expanded taskList() {
    return Expanded(
      child: Padding(
        padding: Styles.defaultPadding,
        child: Obx(
          () => ListView.builder(
            itemBuilder: (context, index) {
              List<Task> tasks = _taskController.allTasks;
              return TTile(
                task: tasks[index],
                ontap: () => _showBottomSheet(context, tasks[index]),
              );
            },
            itemCount: _taskController.allTasks.length,
            physics: const BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }

  Container bottomSheet(BuildContext context, Task task) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 4.0,
          color: Themes.primaryColor,
        ),
        borderRadius: BorderRadius.circular(4.0),
        color: context.theme.scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            task.title,
            textAlign: TextAlign.center,
            style: Styles.regularTextStyle(
              size: 22.0,
              color: context.theme.errorColor,
            ),
          ),
          Expanded(child: Container()),
          TButton(
            ontap: task.isCompleted == 0 && task.isDeserted == 0
                ? () {
                    _taskController.setCompleted(task: task);
                    _taskController.getTasks(
                      date: Utils.dateToString(date: _selectedDate),
                    );
                    Get.back();
                  }
                : null,
            label: "Complete Task",
            color: task.isCompleted == 0 && task.isDeserted == 0
                ? Themes.primaryColor
                : Colors.grey,
          ),
          const SizedBox(height: 8.0),
          TButton(
            ontap: () {
              _taskController.deleteTask(task: task);
              _taskController.getTasks(
                date: Utils.dateToString(date: _selectedDate),
              );
              Get.back();
            },
            label: "Delete Task",
          ),
          const SizedBox(height: 8.0),
          TButton(
            ontap: () {
              Get.back();
            },
            label: "Cancel",
            color: Themes.primaryColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Column allTasksList(BuildContext context) {
    return Column(
      children: [
        TButton(
            ontap: () {
              Get.back();
            },
            label: "Cancel"),
        const SizedBox(height: 12.0),
        Text(
          "Long press to delete the task",
          textAlign: TextAlign.center,
          style: Styles.regularTextStyle(
            size: 18.0,
            color: context.theme.errorColor,
          ),
        ),
        const SizedBox(height: 12.0),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: Themes.primaryColor,
              ),
              borderRadius: BorderRadius.circular(4.0),
              color: context.theme.scaffoldBackgroundColor,
            ),
            child: Obx(() => ListView.builder(
                  itemBuilder: (context, index) {
                    List<Task> tasks = _taskController.tasks;
                    return tasks.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No Tasks Yet",
                                textAlign: TextAlign.center,
                                style: Styles.regularTextStyle(
                                  size: 24.0,
                                  color: context.theme.errorColor,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              IconTheme(
                                data: context.theme.iconTheme
                                    .copyWith(size: 120.0),
                                child: const Icon(Icons.priority_high_rounded),
                              ),
                            ],
                          )
                        : TTile(
                            task: tasks[index],
                            showOption: false,
                            // ontap: () {
                            //   _taskController.setDeserted(task: tasks[index]);
                            //   _taskController.getTasks(
                            //       date:
                            //           Utils.dateToString(date: _selectedDate));
                            // },
                            onlongtap: () {
                              _taskController.deleteTask(task: tasks[index]);
                              _taskController.getTasks(
                                  date:
                                      Utils.dateToString(date: _selectedDate));
                            },
                          );
                  },
                  itemCount: _taskController.tasks.isEmpty
                      ? 1
                      : _taskController.tasks.length,
                  physics: const BouncingScrollPhysics(),
                )),
          ),
        ),
      ],
    );
  }
}
