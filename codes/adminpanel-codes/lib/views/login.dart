import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missyou_admin/color.dart';
import 'package:missyou_admin/views/users_list.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController id = new TextEditingController();
  TextEditingController passwd = new TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {},
      child: Scaffold(
          key: _scaffoldKey,
          body: OrientationBuilder(builder: (context, orientation) {
            if (MediaQuery.of(context).size.width > 600) {
              isLargeScreen = true;
            } else {
              isLargeScreen = false;
            }
            return Center(
              child: Container(
                width: isLargeScreen
                    ? MediaQuery.of(context).size.width * .5
                    : MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 28.0)),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                      elevation: 11,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        cursorColor: mainColor,
                        controller: id,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black26,
                            ),
                            suffixIcon: Icon(
                              Icons.check_circle,
                              color: Colors.black26,
                            ),
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.black26),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        cursorColor: mainColor,
                        controller: passwd,
                        obscureText: !showPass,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black26,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.black26,
                            ),
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: showPass ? mainColor : Colors.black26,
                              onPressed: () {
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.0),
                      child: isLoading
                          ? CupertinoActivityIndicator(
                              radius: 16,
                            )
                          : RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              color: mainColor,
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(40.0))),
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.push(context, CupertinoPageRoute(builder: (context) => Users()));
                              },
/*  onPressed: () async {
                                bool isValid = await auth(id.text, passwd.text);
                                snackbar(
                                    isValid ? "Logged in Successfully..." : "Incorrect Username or Password!",
                                    _scaffoldKey);
                                if (isValid) {
                                  final sharedPrefs = await SharedPreferences.getInstance();
                                  sharedPrefs.setBool('isAuth', true);
                                  Navigator.push(context, CupertinoPageRoute(builder: (context) => Users()));
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },*/
                            ),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }

  Future auth(String id, String paswd) async {
    setState(() {
      isLoading = true;
    });
    Map authData = await Firestore.instance.collection("Admin").document("id_password").get().then((value) {
      return value.data;
    });

    if (authData['id'] == id && authData['password'] == paswd) {
      return true;
    }
    return false;
  }
}

snackbar(String text, GlobalKey<ScaffoldState> _scaffoldKey) {
  final snackBar = SnackBar(
    backgroundColor: Color(0xffff3a5a),
    content: Text('$text '),
    duration: Duration(seconds: 3),
  );
  _scaffoldKey.currentState.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(snackBar);
}
