import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_dashboard_frontend/api_connection/api_connection.dart';
import 'package:personal_dashboard_frontend/data/personalDashboard.dart';
import 'package:personal_dashboard_frontend/pages/drawingPD.dart';

class UserPage extends StatefulWidget {
  UserPage(
      {Key? key, required this.title, required this.id, required this.headers})
      : super(key: key);

  final String title;
  final int id;
  final dynamic headers;

  _UserPageStatus createState() => _UserPageStatus();
}

class _UserPageStatus extends State<UserPage> with TickerProviderStateMixin {
  late AnimationController controller;
  Future<List<PersonalDashboard>>? pd_list;

  @override
  void initState() {
    super.initState();
    pd_list = getPDsFromUser(widget.id, widget.headers);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonalDashboard>>(
        future: pd_list,
        builder:
            (BuildContext context, AsyncSnapshot<List<PersonalDashboard>> pds) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [createDropDownList(pds, controller)],
              ),
            ),
          );
        });
  }

  Widget createDropDownList(
      AsyncSnapshot<List<PersonalDashboard>> pds, controller) {
    switch (pds.connectionState) {
      case ConnectionState.done:
        if (pds.hasData) {

          var items = pds.data!.map((PersonalDashboard pd) {
            return DropdownMenuItem<PersonalDashboard>(
              value: pd,
              child: Text(pd.name),
            );
          }).toList();

          return DropdownButton<PersonalDashboard>(
            hint: Text('Please select dashboard'),
            items: items,
            onChanged: (pd){
              setState(() {
                // TODO make the pages for pds
                  print(pd!.type_of_pd);

                  switch(pd.type_of_pd)
                  {
                    case 'DRAWING':
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context) =>DrawingPdPage(title: pd.name)));

                      break;
                  }

              });
            },
          );
        } else {
          return CircularProgressIndicator(
            value: controller.value,
            color: Colors.purple,
            backgroundColor: Colors.purple[500],
            semanticsLabel: "Loading...",
          );
        }

      default:
        return CircularProgressIndicator(
          value: controller.value,
          color: Colors.purple,
          backgroundColor: Colors.purple[200],
          semanticsLabel: "Loading...",
        );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
