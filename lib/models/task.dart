import 'dart:convert';

class Task {
  int? id;
  String title;
  String note;
  String date;
  String startTime;
  String endTime;
  int remind;
  String repeat;
  int color;
  int isCompleted;
  int isDeserted;
  Task({
    this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.color,
    required this.isCompleted,
    required this.isDeserted,
  });

  Task copyWith({
    int? id,
    String? title,
    String? note,
    String? date,
    String? startTime,
    String? endTime,
    int? remind,
    String? repeat,
    int? color,
    int? isCompleted,
    int? isDeserted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remind: remind ?? this.remind,
      repeat: repeat ?? this.repeat,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeserted: isDeserted ?? this.isDeserted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'color': color,
      'isCompleted': isCompleted,
      'isDeserted': isDeserted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      note: map['note'] as String,
      date: map['date'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      remind: map['remind'] as int,
      repeat: map['repeat'] as String,
      color: map['color'] as int,
      isCompleted: map['isCompleted'] as int,
      isDeserted: map['isDeserted'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, title: $title, note: $note, date: $date, startTime: $startTime, endTime: $endTime, remind: $remind, repeat: $repeat, color: $color, isCompleted: $isCompleted, isDeserted: $isDeserted)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.note == note &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.remind == remind &&
        other.repeat == repeat &&
        other.color == color &&
        other.isCompleted == isCompleted &&
        other.isDeserted == isDeserted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        note.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        remind.hashCode ^
        repeat.hashCode ^
        color.hashCode ^
        isCompleted.hashCode ^
        isDeserted.hashCode;
  }

  void setCompleted() {
    isCompleted = 1;
  }

  void setDeserted() {
    isDeserted = 1;
  }
}
