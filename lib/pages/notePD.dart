import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:personal_dashboard_frontend/api_connection/api_connection.dart';
import 'package:personal_dashboard_frontend/data/data.dart';
import 'dart:math' as math;
import 'package:collection/collection.dart';

class NotePdPage extends StatefulWidget {
  NotePdPage(
      {Key? key, required this.title, required this.cookie, required this.pd})
      : super(key: key);

  final String title;
  final dynamic cookie;
  final int pd;

  _NotePdPageStatus createState() => _NotePdPageStatus();
}

class _NotePdPageStatus extends State<NotePdPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Note>> noteList;
  late List<Note> notes;
  bool gotItems = false;
  late Color dialogColorPicker;
  late AnimationController controller;
  late List<Color?> colorList;

  @override
  void initState() {
    noteList = getNotes(widget.cookie, widget.title, widget.pd);
    dialogColorPicker = Colors.red;
    colorList = List<Color?>.filled(20, Colors.red);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 30.0, 0.0),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OColorPicker(
                      selectedColor: dialogColorPicker,
                      colors: primaryColorsPalette,
                      onColorChange: (color) {
                        setState(() {
                          dialogColorPicker = color;
                          colorList = notes.mapIndexed((index, element) {
                            num val = (index+1)/(notes.length*5);
                            print(index+1);
                            print(notes.length);
                            print(val);
                            return lighten(dialogColorPicker, val as double);
                          }).toList();


                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            icon: Icon(Icons.brush),
          )
        ],
      ),
      drawer: Container(
        width: 200,
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          _scaffoldKey.currentState!.openDrawer();
        },
        child: Center(
          child: FutureBuilder<List<Note>>(
            future: noteList,
            builder:
                (BuildContext build, AsyncSnapshot<List<Note>> note_list_sp) {
              switch (note_list_sp.connectionState) {
                case ConnectionState.done:
                  if (note_list_sp.hasData) {
                    if (!gotItems) {
                      notes = note_list_sp.data as List<Note>;
                      gotItems = true;
                      }

                      return note_list_create();
                    }

                  return Text('add button');
                default:
                  return Center(
                    child: CircularProgressIndicator(
                      value: controller.value,
                      color: Colors.purple,
                      backgroundColor: Colors.purple[200],
                      semanticsLabel: "Loading...",
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget note_list_create() {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.grey[300],
      ),
      child: ReorderableListView.builder(
        itemCount: notes.length,
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        onReorder: (old_ind, new_ind) {
          new_ind -= (old_ind < new_ind) ? 1 : 0;

          final Note note = notes.removeAt(old_ind);
          notes.insert(new_ind, note);
        },
        itemBuilder: (BuildContext context, int index) {
          return PhysicalModel(
            elevation: 0,
            key: Key('$index'),
            color: colorList[index] as Color,
            child: ListTile(
              title: Text(notes[index].title),
              trailing: Icon(Icons.more_vert),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

