class Datehelper {
  static int epochFromDate(DateTime dt) => dt.millisecondsSinceEpoch ~/ 1000;
  static DateTime dateFromepoch(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}
