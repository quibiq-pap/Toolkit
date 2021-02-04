import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotePage extends StatefulWidget{
  @override
  SharedPreferences _prefs;
  List<String> _notes = [];

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _notes = _prefs.getStringList('notes') ?? [];
  }
  State<StatefulWidget> createState() {
    return _NotePage();
  }
}

class _NotePage extends State<NotePage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

    @override
    void initState() {
      widget.initPreferences();
      super.initState();
    }

    get notes{
      return widget._notes;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notizen"),
      ),
      body: Container(
        child: Column(
            children:[
              Expanded( child: notesView(context)), //Column and List needs expanded
              TextField(controller: controller),
              ElevatedButton(
                child: Text('Einfügen'),
                onPressed: _addNote,
              ),
            ]
        ),
      )
    );
  }

  Widget notesView(BuildContext context) {

    return ListView.builder(
      reverse: true,
      itemCount: widget._notes.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text('${widget._notes[index]}'),
          ),
        );
      },
    );
  }

  void _addNote() {
    if (controller.text.isEmpty) return;
    else {
      setState(() {
        widget._notes.add(controller.text);
        controller.text = '';
        print(widget._notes);
        widget._prefs.setStringList('notes', widget._notes);
      });
    }
  }

}

