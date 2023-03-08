import 'package:cool_todo/models/task.dart';
import 'package:cool_todo/views/palette/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TTile extends StatelessWidget {
  const TTile({
    super.key,
    required this.task,
    this.ontap,
    this.onlongtap,
    this.showOption = true,
  });

  final Task task;
  final GestureTapCallback? ontap;
  final GestureLongPressCallback? onlongtap;
  final bool showOption;

  @override
  Widget build(BuildContext context) {
    // late Color bgColor;
    // if (showOption) {
    //   bgColor = Color(task.color);
    // } else {
    //   if (task.isCompleted == 1) {
    //     bgColor = Color(task.color).withOpacity(0.5);
    //   } else if (task.isDeserted == 1) {
    //     bgColor = context.theme.dialogBackgroundColor;
    //   } else {
    //     bgColor = Color(task.color);
    //   }
    // }
    return GestureDetector(
      onLongPress: onlongtap,
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.only(left: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: !showOption && task.isDeserted == 1
              ? context.theme.dialogBackgroundColor
              : !showOption && task.isCompleted == 1
                  ? Color(task.color).withOpacity(0.5)
                  : Color(task.color),
          borderRadius: showOption
              ? const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                )
              : BorderRadius.circular(8.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: showOption
                      ? const EdgeInsets.symmetric(vertical: 8.0)
                      : const EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text("► "),
                          Text(
                            task.startTime,
                            style: Styles.lightTextStyle(
                              size: 14.0,
                              color: context.theme.errorColor,
                            ),
                          ),
                          Expanded(
                            child: showOption
                                ? Text(
                                    task.remind == 0
                                        ? "No Reminder"
                                        : "${task.remind} Minutes\nReminder",
                                    textAlign: TextAlign.center,
                                    style: Styles.regularTextStyle(
                                      size: 12.0,
                                      color:
                                          context.theme.scaffoldBackgroundColor,
                                    ),
                                  )
                                : Text(
                                    task.date,
                                    textAlign: TextAlign.center,
                                    style: Styles.regularTextStyle(
                                      size: 16.0,
                                      color: context.theme.errorColor,
                                    ),
                                  ),
                          ),
                          Text(
                            task.endTime,
                            style: Styles.lightTextStyle(
                              size: 14.0,
                              color: context.theme.errorColor,
                            ),
                          ),
                          const Text(" ◄"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          task.title,
                          textAlign: TextAlign.start,
                          style: Styles.boldTextStyle(
                            size: 20.0,
                            color: context.theme.errorColor,
                          ),
                        ),
                      ),
                      Text(
                        task.note,
                        textAlign: TextAlign.start,
                        style: Styles.lightTextStyle(
                          size: 20.0,
                          color: context.theme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              showOption
                  ? GestureDetector(
                      onTap: ontap,
                      onLongPress: onlongtap,
                      child: Container(
                        width: 40.0,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 8.0),
                        decoration: BoxDecoration(
                          color: Color(task.color),
                          border: Border(
                            left: BorderSide(
                              width: 4.0,
                              color: context.theme.scaffoldBackgroundColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            task.isCompleted == 0 ? "options" : "Completed",
                            style: Styles.regularTextStyle(
                              size: 16.0,
                              color: context.theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
