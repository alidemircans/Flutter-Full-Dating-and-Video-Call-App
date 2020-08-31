import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou/views/ShowGender.dart';
import 'package:missyou/util/color.dart';
import 'package:missyou/util/snackbar.dart';

class SexualOrientation extends StatefulWidget {
  final Map<String, dynamic> userData;
  SexualOrientation(this.userData);

  @override
  _SexualOrientationState createState() => _SexualOrientationState();
}

class _SexualOrientationState extends State<SexualOrientation> {
  List<Map<String, dynamic>> orientationlist = [
    {'name': 'Normal', 'ontap': false},
    {'name': 'Gay', 'ontap': false},
    {'name': 'Asexual', 'ontap': false},
    {'name': 'Lezbiyen', 'ontap': false},
    {'name': 'Bisexual', 'ontap': false},
    {'name': 'Demisexual', 'ontap': false},
  ];
  List selected = [];
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: FloatingActionButton(
            elevation: 10,
            child: IconButton(
              color: secondryColor,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white38,
            onPressed: () {
              dispose();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(
                  "My sexual orientation",
                  style: TextStyle(fontSize: 40),
                ),
                padding: EdgeInsets.only(left: 50, top: 80),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 50),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orientationlist.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: OutlineButton(
                        highlightedBorderColor: primaryColor,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .055,
                          width: MediaQuery.of(context).size.width * .65,
                          child: Center(
                              child: Text("${orientationlist[index]["name"]}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: orientationlist[index]["ontap"] ? primaryColor : secondryColor,
                                      fontWeight: FontWeight.bold))),
                        ),
                        borderSide: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: orientationlist[index]["ontap"] ? primaryColor : secondryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        onPressed: () {
                          setState(() {
                            if (selected.length < 3) {
                              orientationlist[index]["ontap"] = !orientationlist[index]["ontap"];
                              if (orientationlist[index]["ontap"]) {
                                selected.add(orientationlist[index]["name"]);
                                print(orientationlist[index]["name"]);
                                print(selected);
                              } else {
                                selected.remove(orientationlist[index]["name"]);
                                print(selected);
                              }
                            } else {
                              if (orientationlist[index]["ontap"]) {
                                orientationlist[index]["ontap"] = !orientationlist[index]["ontap"];
                                selected.remove(orientationlist[index]["name"]);
                              } else {
                                CustomSnackbar.snackbar("select upto 3", _scaffoldKey);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: Checkbox(
                      activeColor: primaryColor,
                      value: select,
                      onChanged: (bool newValue) {
                        setState(() {
                          select = newValue;
                        });
                      },
                    ),
                    title: Text("Show my profile "),
                  ),
                  selected.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            primaryColor.withOpacity(.5),
                                            primaryColor.withOpacity(.8),
                                            primaryColor,
                                            primaryColor
                                          ])),
                                  height: MediaQuery.of(context).size.height * .065,
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: Center(
                                      child: Text(
                                    "Go on",
                                    style: TextStyle(
                                        fontSize: 15, color: textColor, fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () {
                                widget.userData.addAll({
                                  "sexualOrientation": {'orientation': selected, 'showOnProfile': select},
                                });
                                print(widget.userData);
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) => ShowGender(widget.userData)));
                              },
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  height: MediaQuery.of(context).size.height * .065,
                                  width: MediaQuery.of(context).size.width * .75,
                                  child: Center(
                                      child: Text(
                                    "Go on",
                                    style: TextStyle(
                                        fontSize: 15, color: secondryColor, fontWeight: FontWeight.bold),
                                  ))),
                              onTap: () {
                                CustomSnackbar.snackbar("Please select one", _scaffoldKey);
                              },
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
