import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_painting_tools/flutter_painting_tools.dart';
import 'package:personal_dashboard_frontend/api_connection/api_connection.dart';
import 'package:personal_dashboard_frontend/data/personalDashboard.dart';

class DrawingPdPage extends StatefulWidget {
  DrawingPdPage({Key? key, required this.title}) : super(key: key);

  final String title;

  _DrawingPdPageStatus createState() => _DrawingPdPageStatus();
}

class _DrawingPdPageStatus extends State<DrawingPdPage> {
  late final PaintingBoardController controller;

  Color pickerColor0 = Colors.grey;
  Color pickerColor1 = Colors.blue;
  Color backgroundColor = Colors.grey;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() {
      pickerColor0 = color;
      controller.changeBrushColor(color);
    });
  }

  void changeColor1(Color color) {
    setState(() {
      pickerColor1 = color;
    });
  }

  @override
  void initState() {
    controller = PaintingBoardController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                controller.deleteLastLine();
              },
              icon: Icon(Icons.arrow_back)),
          IconButton(
              onPressed: () {
                controller.deletePainting();
              },
              icon: Icon(Icons.delete)),
        ],
      ),

      drawer: Container(
        width: 200,
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {/*TODO save item to database*/},
                  child: Text('Save'),
                ),
              ),

              choosingButtons('Choose background color', 'Background color',
                  context, pickerColor1, changeColor1),
              choosingButtons('Choose brush color', 'Brush color', context,
                  pickerColor0, changeColor),
            ],
          ),
        ),
      ),


    body: GestureDetector(
    onPanUpdate: (details){
    _scaffoldKey.currentState!.openDrawer();
    },
    child: Center(
    child: Column(
    children: [

    Expanded(
    child: PaintingBoard(
    controller: controller,
    boardBackgroundColor: backgroundColor,

    ),
    ),

    // colorPickerCreate(pickerColor0, changeColor),
    // colorPickerCreate(pickerColor1, changeColor1)
    ],
    ),
    ),
    ));
    }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

Widget colorPickerCreate(pickerColor, changeColor) {
  return ColorPicker(
    pickerColor: pickerColor,
    onColorChanged: changeColor,
    showLabel: true,
    pickerAreaHeightPercent: 0.7,
  );
}

Widget choosingButtons(buttonText, alertText, context, color, colorChangeFunc) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 70,
      width: 150,
      child: ElevatedButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(alertText),
                    content: SizedBox(
                      width: 300,
                      height: 450,
                      child: Column(
                        children: [
                          colorPickerCreate(color, colorChangeFunc),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok')),
                        ],
                      ),
                    ),
                  ));
        },
        child: Text(buttonText),
      ),
    ),
  );
}
