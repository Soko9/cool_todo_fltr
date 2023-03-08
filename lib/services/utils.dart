import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String dateToString({required DateTime date}) =>
      DateFormat("dd/MM/yyyy").format(date);

  static DateTime stringToDate({required String date}) {
    List<String> dt = date.split("/");
    return DateTime(int.parse(dt[2]), int.parse(dt[1]), int.parse(dt[0]));
  }

  static String timeToString({
    required BuildContext context,
    required TimeOfDay time,
  }) =>
      time.format(context);

  static DateTime stringToTime({required String date, required String time}) {
    List<String> tm = time.split(" ");
    List<String> tt = tm[0].split(":");
    return DateTime(
      int.parse(date.split("/")[2]),
      int.parse(date.split("/")[1]),
      int.parse(date.split("/")[0]),
      tm[1] == "AM" ? int.parse(tt[0]) : int.parse(tt[0]) + 12,
      int.parse(tt[1]),
    );
  }

  static int howManyMinutes({
    required DateTime date,
    required TimeOfDay time,
    required int reminder,
  }) {
    DateTime nowD = DateTime.now();
    TimeOfDay nowT = TimeOfDay.now();

    int timeLeftForToday = date.isAfter(nowD)
        ? (23 * 60 + 59) - (nowT.hour * 60 + nowT.minute)
        : 0;
    int totalDays = date.difference(nowD).inDays * 24 * 60;
    int timeRemaining =
        (time.hour - nowT.hour) * 60 + (time.minute - nowT.minute);

    return timeLeftForToday + totalDays + timeRemaining - reminder;
  }
}
