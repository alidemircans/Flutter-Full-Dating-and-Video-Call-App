import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou/views/Tab.dart';
import 'package:missyou/util/color.dart';
import 'package:geolocator/geolocator.dart';

class AllowLocation extends StatelessWidget {
  final Map<String, dynamic> userData;
  AllowLocation(this.userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    backgroundColor: secondryColor.withOpacity(.2),
                    radius: 110,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(40),
                    child: RichText(
                      text: TextSpan(
                        text: "Allow Location",
                        style: TextStyle(color: Colors.black, fontSize: 40),
                        children: [
                          TextSpan(
                              text: """\nYou must allow the location
                              """,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: secondryColor,
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 18)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
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
                        "Admit it",
                        style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),
                      ))),
                  onTap: () async {
                    var currentLocation =
                        await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                    List<Placemark> pm = await Geolocator()
                        .placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);
                    userData.addAll(
                      {
                        'location': {
                          'latitude': currentLocation.latitude,
                          'longitude': currentLocation.longitude,
                          'address':
                              "${pm[0].locality} ${pm[0].subLocality} ${pm[0].subAdministrativeArea}\n ${pm[0].country} ,${pm[0].postalCode}"
                        },
                        'maximum_distance': 20,
                        'age_range': {
                          'min': "20",
                          'max': "50",
                        },
                      },
                    );

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.pop(context);
                            Navigator.push(
                                context, CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
                          });
                          return Center(
                              child: Container(
                                  width: 150.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        "asset/auth/verified.jpg",
                                        height: 60,
                                        color: primaryColor,
                                        colorBlendMode: BlendMode.color,
                                      ),
                                      Text(
                                        "Receipt",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 20),
                                      )
                                    ],
                                  )));
                        });
                    _setUserData(userData);
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Future _setUserData(Map<String, dynamic> userData) async {
  await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
    await Firestore.instance.collection("Users").document(user.uid).setData(userData, merge: true);
  });
}
