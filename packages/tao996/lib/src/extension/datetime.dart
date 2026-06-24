extension DateTimeExt on DateTime {
  String toYMDString() {
    int year = this.year;
    int month = this.month;
    String formattedMonth = month.toString().padLeft(2, '0');

    int day = this.day;
    String formattedDay = day.toString().padLeft(2, '0');
    return '$year-$formattedMonth-$formattedDay';
  }
}
