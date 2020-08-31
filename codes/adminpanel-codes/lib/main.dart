import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missyou_admin/views/login.dart';
import 'package:missyou_admin/views/users_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;
  @override
  void initState() {
    print("object");

    _checkAuth();
    super.initState();
  }

//Create default id password
  Future _setIdPass() async {
    await Firestore.instance.collection("Admin").document("id_password").get().then((value) async {
      if (value.data == null) {
        await Firestore.instance
            .collection("Admin")
            .document("id_password")
            .setData({"id": "admin_01", "password": "deligence"});
      }
    });
  }

//Check user loggedin or not
  void _checkAuth() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    bool isAuth = sharedPrefs.getBool("isAuth") != null ? sharedPrefs.getBool("isAuth") : false;
    print(isAuth);
    if (isAuth) {
      setState(() {
        isAuthenticated = true;
      });
    } else {
      print("asfasfcas");
      _setIdPass();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xffff3a5a),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: isAuthenticated ? Users() : LoginPage()
        // MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}
