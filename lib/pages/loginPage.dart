import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_dashboard_frontend/api_connection/api_connection.dart';
import 'package:personal_dashboard_frontend/pages/registerPage.dart';
import 'package:personal_dashboard_frontend/pages/userPage.dart';
import 'package:tuple/tuple.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title})
      :super(key: key);

  final String title;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myPassController = TextEditingController();
  final myUserController = TextEditingController();

  showAlertDialog(BuildContext context, code, id, username, headers) {
    AlertDialog alert = AlertDialog(
      title: Text('Login error'),
      content: Text('Username or password incorrect'),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('Ok'))
      ],
    );

    AlertDialog loginAlert = AlertDialog(
      title: Text('Login successful'),
      content: Text('Press Ok to continue'),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder:(context) =>UserPage(title: username, id:id, headers: headers,)));

        }, child: Text('Ok'))
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return code == 1 ? loginAlert : alert;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getTextFormContainer(myUserController, 'username', true),
              getTextFormContainer(myPassController, 'password', false),
              SizedBox(

                child: ElevatedButton(onPressed: () async {
                  Tuple2<int,dynamic> loginData = await login(myUserController.text,
                      myPassController.text);

                  var headears = loginData.item2;
                  int loginSuccessful = loginData.item1;
                  if (loginSuccessful != -1) {
                    showAlertDialog(context, 1, loginSuccessful, myUserController.text, headears); //OK
                    return;
                  }
                  else {
                    showAlertDialog(context, 0, loginSuccessful, myUserController.text, headears); // NOT OK
                    return;
                  }
                }, child: Text('Login')),
              )
            ],
          ),
        ),
    );
  }

  @override
  void dispose() {
    myPassController.dispose();
    myUserController.dispose();
    super.dispose();
  }

}


Container getTextFormContainer(controller, text, isVisible) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: TextFormField(
      cursorColor: Colors.purple,
      obscureText: !isVisible,
      controller: controller,
      decoration: InputDecoration(border: OutlineInputBorder(),
          hintText: text,
          hoverColor: Colors.purple,
          fillColor: Colors.purple),

    ),
  );
}