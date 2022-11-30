import 'package:intl/intl.dart';

enum DateFormatType { year, yearTime, time }

class DateFormatService {
  /// to format date with intl package.
  static String formattedDate(String date,
      {DateFormatType dateFormatType = DateFormatType.yearTime}) {
    String format = '';
    if (dateFormatType == DateFormatType.year) {
      format = 'dd-MM-yyyy';
    } else if (dateFormatType == DateFormatType.yearTime) {
      format = 'dd-MM-yyyy hh:mm a';
    } else if (dateFormatType == DateFormatType.time) {
      format = 'hh:mm a';
    }

    final parsedDate = DateTime.parse(date).toLocal();
    return DateFormat(format).format(parsedDate);
  }
}
