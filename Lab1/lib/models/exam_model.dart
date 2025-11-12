class Exam {
  String name;
  DateTime dateTime;
  List<String> classrooms;

  Exam({required this.name, required this.dateTime, required this.classrooms});

  bool get isPassed => DateTime.now().isAfter(dateTime);

  String getDaysAndHoursUntil() {
    if (isPassed) return 'Испитот е завршен';
    final diff = dateTime.difference(DateTime.now());
    final days = diff.inDays;
    final hours = diff.inHours.remainder(24);
    return '$days дена, $hours часа';
  }
}