import 'package:cool_todo/controllers/task_controller.dart';
import 'package:cool_todo/models/task.dart';
import 'package:cool_todo/services/notifications.dart';
import 'package:cool_todo/services/utils.dart';
import 'package:cool_todo/views/palette/styles.dart';
import 'package:cool_todo/views/palette/themes.dart';
import 'package:cool_todo/views/widgets/t_button.dart';
import 'package:cool_todo/views/widgets/t_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.put(TaskController());
  late final Notifications notifications;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  late int _selectedReminder;
  late String _selectedRepeat;
  late Color _selectedColor;

  List<int> reminders = [0, 5, 10, 15, 20];
  List<String> repeats = ["None", "Daily", "Weekly", "Monthly"];

  _getDate() async {
    DateTime now = DateTime.now();

    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(now.year, now.month + 3),
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          dialogBackgroundColor: context.theme.scaffoldBackgroundColor,
          colorScheme: ColorScheme.light(
            primary: Themes.primaryColor,
            onPrimary: context.theme.scaffoldBackgroundColor,
            surface: context.theme.scaffoldBackgroundColor,
            onSurface: context.theme.errorColor,
          ),
        ),
        child: child!,
      ),
    );

    setState(() {
      // if (picker!.isAfter(DateTime(now.year, now.month, now.day - 1))) {
      _selectedDate = picker!;
      // }
    });
  }

  _getStartTime() async {
    TimeOfDay? picker = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          colorScheme: Get.isDarkMode
              ? const ColorScheme.dark(
                  primary: Themes.primaryColor,
                )
              : const ColorScheme.light(
                  primary: Themes.primaryColor,
                ),
        ),
        child: child!,
      ),
    );

    setState(() {
      _selectedStartTime = picker!;
    });
  }

  _getEndTime() async {
    TimeOfDay? picker = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
      builder: (context, child) => Theme(
        data: context.theme.copyWith(
          colorScheme: Get.isDarkMode
              ? const ColorScheme.dark(
                  primary: Themes.primaryColor,
                )
              : const ColorScheme.light(
                  primary: Themes.primaryColor,
                ),
        ),
        child: child!,
      ),
    );

    setState(() {
      _selectedEndTime = picker!;
    });
  }

  _creatTask() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Error: Missing Fields",
        "Title and Note fields are required!",
        colorText: Colors.red,
        icon: const Icon(Icons.error_rounded, color: Colors.red),
      );
    } else {
      _addTaskToDB();
      Get.back();
    }
  }

  _addTaskToDB() async {
    int id = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      date: Utils.dateToString(date: _selectedDate),
      startTime: Utils.timeToString(context: context, time: _selectedStartTime),
      endTime: Utils.timeToString(context: context, time: _selectedEndTime),
      remind: _selectedReminder,
      repeat: _selectedRepeat,
      color: _selectedColor.value,
      isCompleted: 0,
      isDeserted: 0,
    ));

    DateTime dt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute - _selectedReminder,
    );

    DateTime now = DateTime.now();
    Duration rdt = dt.difference(now);

    Get.snackbar(
      "Reminder",
      "${rdt.inDays} day(s) and ${rdt.inMinutes % (24 * 60)} minute(s) remains till the task",
      icon: Icon(Icons.info_outline_rounded, color: context.theme.errorColor),
      colorText: context.theme.errorColor,
      duration: const Duration(seconds: 4),
    );

    notifications.displayScheduledNotification(
      title: _titleController.text,
      body: _noteController.text,
      datetime: dt,
      id: id,
    );
    debugPrint("Last id $id");
  }

  @override
  void initState() {
    super.initState();
    notifications = Notifications();
    notifications.initializeNotification();
    notifications.requestIOSPermissions();
    _selectedReminder = reminders[0];
    _selectedRepeat = repeats[0];
    _selectedColor = Themes.darkBlue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: Styles.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: Styles.boldTextStyle(
                  size: 30.0,
                  color: Themes.primaryColor,
                ),
              ),
              TInput(
                title: "Title",
                hint: "ex: Finishing Chores",
                controller: _titleController,
              ),
              TInput(
                title: "Note",
                hint: "ex: Cleaning my room",
                controller: _noteController,
              ),
              TInput(
                title: "Date",
                hint: DateFormat.yMMMMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDate();
                  },
                  icon: IconTheme(
                    data: context.theme.iconTheme,
                    child: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TInput(
                      title: "Start Time",
                      hint: _selectedStartTime.format(context),
                      widget: IconButton(
                        onPressed: () {
                          _getStartTime();
                        },
                        icon: IconTheme(
                          data: context.theme.iconTheme,
                          child: const Icon(Icons.watch_later_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 22.0),
                  Expanded(
                    child: TInput(
                      title: "End Time",
                      hint: _selectedEndTime.format(context),
                      widget: IconButton(
                        onPressed: () {
                          _getEndTime();
                        },
                        icon: IconTheme(
                          data: context.theme.iconTheme,
                          child: const Icon(Icons.watch_later_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TInput(
                title: "Reminder",
                hint: "",
                extend: true,
                height: 64.0,
                widget: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: CupertinoPicker(
                    itemExtent: 35.0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        _selectedReminder = reminders[value];
                      });
                    },
                    looping: true,
                    diameterRatio: 1.1,
                    children: reminders
                        .map(
                          (reminder) => Text(
                            reminder == 0
                                ? "no reminder"
                                : "$reminder minutes earlier",
                            textAlign: TextAlign.center,
                            style: Styles.regularTextStyle(
                              size: 18.0,
                              color: context.theme.backgroundColor,
                            ).copyWith(height: 1.7),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              // TInput(
              //   title: "Repeat",
              //   hint: "",
              //   extend: true,
              //   height: 64.0,
              //   widget: Container(
              //     alignment: Alignment.center,
              //     width: MediaQuery.of(context).size.width / 1.5,
              //     child: CupertinoPicker(
              //       itemExtent: 35.0,
              //       onSelectedItemChanged: (value) {
              //         setState(() {
              //           _selectedRepeat = repeats[value];
              //         });
              //       },
              //       looping: true,
              //       diameterRatio: 1.1,
              //       children: repeats
              //           .map(
              //             (repeat) => Text(
              //               repeat,
              //               textAlign: TextAlign.center,
              //               style: Styles.regularTextStyle(
              //                 size: 18.0,
              //                 color: context.theme.backgroundColor,
              //               ).copyWith(height: 1.7),
              //             ),
              //           )
              //           .toList(),
              //     ),
              //   ),
              // ),
              colorPicker(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: IconTheme(
          data: Theme.of(context).iconTheme,
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
    );
  }

  GestureDetector colorBox({required Color color}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Opacity(
        opacity: _selectedColor == color ? 1.0 : 0.4,
        child: Container(
          height: _selectedColor == color ? 42.0 : 32.0,
          width: _selectedColor == color ? 42.0 : 32.0,
          margin: const EdgeInsets.only(right: 24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            color: color,
          ),
        ),
      ),
    );
  }

  Padding colorPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Colors",
                style: Styles.regularTextStyle(
                  size: 18.0,
                  color: context.theme.backgroundColor,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  colorBox(color: Themes.darkBlue),
                  colorBox(color: Themes.darkRed),
                  colorBox(color: Themes.darkGreen),
                ],
              ),
            ],
          ),
          TButton(ontap: _creatTask, label: "Create Task"),
        ],
      ),
    );
  }
}
