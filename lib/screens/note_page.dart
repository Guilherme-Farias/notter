import 'package:flutter/material.dart';
import 'package:notter/database/dao/note_dao.dart';
import 'package:notter/models/note.dart';

class NotePage extends StatefulWidget {
  final Note noteInEditing;
  NotePage(this.noteInEditing);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  NoteDao noteDao = new NoteDao();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.noteInEditing.title;
    _contentController.text = widget.noteInEditing.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return DeleteDialog(noteDao: noteDao, widget: widget);
                    });
              })
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          _isNew() ? 'New Note' : 'Edit Note',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: 'Enter title...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _contentController,
                decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 18, color: Colors.black)),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () {
                widget.noteInEditing.title = _titleController.text;
                widget.noteInEditing.content = _contentController.text;
                widget.noteInEditing.updatedIn = DateTime.now();
                _save(context, widget.noteInEditing);
              },
              child: Text(
                widget.noteInEditing.id == -1 ? 'Add a note' : 'Save a Note',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context, Note note) async {
    await noteDao.insertNote(note, _isNew());
    Navigator.pop(context, note);
  }

  bool _isNew() => widget.noteInEditing.id == -1 ? true : false;
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key key,
    @required this.noteDao,
    @required this.widget,
  }) : super(key: key);

  final NoteDao noteDao;
  final NotePage widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete note'),
      content:
          Text('Are you sure that you want to permanently delete this note?'),
      actions: [
        FlatButton(
          color: Colors.redAccent,
          child: Text('Yes, delete it'),
          onPressed: () {
            noteDao.deleteNote(widget.noteInEditing);
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          },
        ),
        FlatButton(
          color: Colors.grey,
          child: Text(
            'cancel',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
