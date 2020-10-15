import 'package:intl/intl.dart';

class Datehelper {
  static int epochFromDate(DateTime dt) => dt.millisecondsSinceEpoch ~/ 1000;
  static DateTime dateFromepoch(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  static String strFromDate(DateTime dt) =>
      DateFormat('HH:mm - dd/MM/yyyy').format(dt);
}
