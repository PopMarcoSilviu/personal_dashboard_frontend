import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawing_board/drawing_board.dart';
import 'package:flutter_drawing_board/drawing_controller.dart';
import 'package:flutter_painting_tools/flutter_painting_tools.dart';
import 'package:personal_dashboard_frontend/api_connection/api_connection.dart';

class DrawingPdPage extends StatefulWidget {
  DrawingPdPage(
      {Key? key, required this.title, required this.cookie, required this.pd})
      : super(key: key);

  final String title;
  final dynamic cookie;
  final int pd;

  _DrawingPdPageStatus createState() => _DrawingPdPageStatus();
}

class _DrawingPdPageStatus extends State<DrawingPdPage> {
  late final DrawingController _drawingController;
  Color pickerColor0 = Colors.grey;
  Color pickerColor1 = Colors.blue;
  Color backgroundColor = Colors.grey;
  Color brushColor = Colors.blue;
  late bool backgroundChanged;
  late Future<Uint8List> drawing;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() {
      pickerColor0 = color;
      // controller.changeBrushColor(color);
    });
  }

  void changeColor1(Color color) {
    setState(() {
      pickerColor1 = color;
    });
  }

  @override
  void initState() {
    backgroundChanged = false;
    _drawingController = DrawingController();
    drawing = getDrawing(widget.cookie, widget.title);
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
          actions: [],
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
                    onPressed: () async {
                      var bytes = await _getImageData();
                      bool saved = await postDrawing(
                          bytes, widget.title, widget.cookie, widget.pd);
                    },
                    child: Text('Save'),
                  ),
                ),
                choosingButtons('Choose background color', 'Background color',
                    context, pickerColor1, changeColor1),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onPanUpdate: (details) {
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Center(
            child: Column(
              children: [
                FutureBuilder<Uint8List>(
                    future: drawing,
                    builder:
                        (BuildContext context, AsyncSnapshot<Uint8List> draw) {

                      switch(draw.connectionState) {
                        case ConnectionState.done:
                          {
                            return Expanded(
                              child: DrawingBoard(
                                  background: (backgroundChanged==true) ? Container(
                                    color: backgroundColor,
                                  ):
                                  Image.memory(draw.data!),
                                  // Text('da')    ,

                              showDefaultTools: false,
                              showDefaultActions: true,
                              controller: _drawingController,
                            ));
                          }

                        default:
                          {
                            return Text('da');
                          }


                      }


                    }),
              ],
            ),
          ),
        ));
  }

  Widget choosingButtons(
      buttonText, alertText, context, color, colorChangeFunc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 70,
        width: 150,
        child: ElevatedButton(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(alertText),
                      content: SizedBox(
                        width: 300,
                        height: 450,
                        child: Column(
                          children: [
                            colorPickerCreate(color, colorChangeFunc),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    backgroundColor = pickerColor1;
                                    brushColor = pickerColor0;
                                    backgroundChanged = true;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Choose')),
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

  Future<Int8List> _getImageData() async {
    return (await _drawingController.getImageData())!.buffer.asInt8List();
  }

  @override
  void dispose() {
    _drawingController.dispose();
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
