import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou_admin/color.dart';
import 'package:missyou_admin/model/customAlert.dart';
import 'package:missyou_admin/views/login.dart';

class ChangeIdPassword extends StatefulWidget {
  @override
  _ChangeIdPasswordState createState() => _ChangeIdPasswordState();
}

class _ChangeIdPasswordState extends State<ChangeIdPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController newId = new TextEditingController();
  TextEditingController newPasswd = new TextEditingController();
  bool isLoading = false;
  bool showPass = false;
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text("Change Id or Password"),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Center(
            child: Container(
              width:
                  isLargeScreen ? MediaQuery.of(context).size.width * .5 : MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Change id or password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 22.0)),
                  Card(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                    elevation: 11,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: TextField(
                      cursorColor: mainColor,
                      controller: newId,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black26,
                          ),
                          suffixIcon: Icon(
                            Icons.check_circle,
                            color: Colors.black26,
                          ),
                          hintText: "Enter new user-id",
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
                      controller: newPasswd,
                      obscureText: !showPass,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black26,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            color: showPass ? mainColor : Colors.black26,
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                          ),
                          hintText: "Enter new password",
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          filled: true,
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
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      color: mainColor,
                      elevation: 11,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                      child: Text(
                        "Change",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BeautifulAlertDialog(
                                text: "Do you want to change the id/password ?",
                                onYesTap: () async {
                                  await Firestore.instance
                                      .collection("Admin")
                                      .document("id_password")
                                      .setData({"id": newId.text, "password": newPasswd.text})
                                      .whenComplete(() => snackbar("changed successfully!!", _scaffoldKey))
                                      .catchError((onError) => snackbar(onError, _scaffoldKey));
                                  Navigator.pop(context);
                                },
                                onNoTap: () => Navigator.pop(context));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
