
import 'package:intl/intl.dart';

bool stringIsNullOrEmpty(String value) {
  return value == null || value.isEmpty;
}

String currentTime() {
  return new DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
}