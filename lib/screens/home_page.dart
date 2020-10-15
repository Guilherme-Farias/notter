import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notter/components/centered_message.dart';
import 'package:notter/components/progress.dart';
import 'package:notter/database/dao/note_dao.dart';
import 'package:notter/helpers/date_helper.dart';
import 'package:notter/models/note.dart';
import 'package:notter/screens/note_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NoteDao noteDao = new NoteDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _fab(),
      body: FutureBuilder<List<Note>>(
        initialData: List(),
        future: noteDao.getAllNotes().timeout(Duration(seconds: 5)),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Progress();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<Note> notes = snapshot.data;
                if (notes.isNotEmpty) {
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final Note note = notes[index];
                      return NoteItem(
                        note,
                        onClick: () => _goToNotePage(note),
                      );
                    },
                  );
                }
              }
              return CenteredMessage(
                'No notes found',
                icon: Icons.description,
                color: Colors.blue,
              );
              break;
          }
          return CenteredMessage('Uknown error');
        },
      ),
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton.extended(
      icon: Icon(Icons.add),
      label: Text('Add note'.toUpperCase()),
      onPressed: () {
        var emptyNote = new Note(-1, "", "", DateTime.now(), DateTime.now());
        _goToNotePage(emptyNote);
      },
    );
  }

  void _goToNotePage(Note note) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NotePage(note)))
        .then((note) {
      setState(() {
        noteDao.getAllNotes();
      });
    });
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Notter',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class NoteItem extends StatelessWidget {
  final Note note;
  final Function onClick;

  const NoteItem(this.note, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 200,
              child: AutoSizeText(
                note.title,
                overflow: TextOverflow.ellipsis,
                minFontSize: 24,
                maxLines: 1,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Text(Datehelper.strFromDate(note.updatedIn))
          ],
        ),
        subtitle: Container(
          width: 10,
          child: AutoSizeText(
            note.content,
            maxFontSize: 50,
            minFontSize: 16,
            maxLines: 1,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
