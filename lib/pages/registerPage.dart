import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_dashboard_frontend/api_connection/api_connection.dart';
import 'package:personal_dashboard_frontend/data/aux_data.dart';
import 'package:personal_dashboard_frontend/data/user.dart';

import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, required this.title})
      :super(key: key);

  final String title;

  _RegisterPageStatus createState() => _RegisterPageStatus();
}

class _RegisterPageStatus extends State<RegisterPage> {

  final controllers = new List<TextEditingController>.generate(5, (index) => TextEditingController());

  showAlertDialog(BuildContext context, code, error_msg)
  {
    AlertDialog alert = AlertDialog(
      title: Text('Registration error'),
      content: Text(error_msg),
      actions: [
        ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('Ok'))
      ],
    );

    AlertDialog loginAlert = AlertDialog(
      title: Text('Register successful'),
      content: Text('Press Ok to go back to login page'),
      actions: [
        ElevatedButton(onPressed: (){Navigator.pop(context);Navigator.pop(context);}, child: Text('Ok'))
      ],
    );

    showDialog(context: context, builder: (BuildContext context)
    {
      return code==1? loginAlert:alert;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: createTextFormFields() + [

            SizedBox(

              child: ElevatedButton(onPressed: () async{
                String registerSuccessful = await register(createUserFromTextForm());

                if(registerSuccessful=='OK')
                  {
                    showAlertDialog(context, 1, "");
                  }
                else
                  {
                    showAlertDialog(context, 0, registerSuccessful);
                  }

              }, child: Text('Register')),
            )

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var field in controllers)
      {
        field.dispose();
      }
    super.dispose();
  }

  List<Widget> createTextFormFields()
  {
    List<Widget> l = [];

    for (var field in ClientField.values)
    {
      bool vis = true;

      if ( field == ClientField.password)
      {
        vis = false;
      }

      l.add(getTextFormContainer(controllers[field.index], field.toString().split('.')[1], vis));
    }

    return l;
  }

  User createUserFromTextForm()
  {
    return User(
      username: controllers[ClientField.username.index].text,
      password: controllers[ClientField.password.index].text,
      email: controllers[ClientField.email.index].text,
      firstName: controllers[ClientField.first_name.index].text,
      lastName: controllers[ClientField.last_name.index].text,
    );
  }

}

