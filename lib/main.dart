import 'package:flutter/material.dart';
import 'package:personal_dashboard_frontend/pages/loginPage.dart';
import 'package:personal_dashboard_frontend/pages/registerPage.dart';
import 'package:personal_dashboard_frontend/theme/custom_theme.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main page',
      theme: CustomTheme.lightTheme,
      routes: {
        '/login' : (context) => LoginPage(title: 'Login page'),
        '/register': (context) => RegisterPage(title: 'Register page'),
      },
      home: Builder(
        builder: (context) =>Scaffold(
          appBar: AppBar(
            title: Text('Main page'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(onPressed: () async {
                  Navigator.pushNamed(context, '/login');
                },
                    child: Text('Login page')),

                ElevatedButton(onPressed: () async {
                  Navigator.pushNamed(context, '/register');
                },
                    child: Text('Register page'))
              ],
            ),
          )
        ),
      ),
    );
  }
}
