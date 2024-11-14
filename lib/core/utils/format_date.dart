import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return DateFormat('d MMM, yyy').format(dateTime);
}
