import 'dart:convert';

import 'package:notter/helpers/date_helper.dart';

class Note {
  int id;
  String title;
  String content;
  DateTime createdIn;
  DateTime updatedIn;

  Note(
    this.id,
    this.title,
    this.content,
    this.createdIn,
    this.updatedIn,
  );

  Map<String, dynamic> toMap(bool forUpdate) {
    var data = {
      'title': utf8.encode(title),
      'content': utf8.encode(content),
      'createdIn': Datehelper.epochFromDate(createdIn),
      'updatedIn': Datehelper.epochFromDate(
          updatedIn), //  for later use for integrating archiving
    };

    if (forUpdate) {
      data['id'] = this.id;
    }
    return data;
  }
}
