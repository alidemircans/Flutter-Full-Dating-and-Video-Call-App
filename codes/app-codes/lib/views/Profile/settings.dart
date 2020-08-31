import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:missyou/views/auth/login.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';
import 'UpdateNumber.dart';

class Settings extends StatefulWidget {
  final User currentUser;
  final bool isPurchased;
  final Map items;
  Settings(this.currentUser, this.isPurchased, this.items);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic> changeValues = {};
  RangeValues ageRange;
  var _showMe;
  int distance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    if (changeValues.length > 0) {
      updateData();
    }
  }

  Future updateData() async {
    Firestore.instance.collection("Users").document(widget.currentUser.id).setData(changeValues, merge: true);
    // lastVisible = null;
    // print('ewew$lastVisible');
  }

  int freeR;
  int paidR;

  @override
  void initState() {
    super.initState();
    freeR = widget.items['free_radius'] != null ? int.parse(widget.items['free_radius']) : 400;
    paidR = widget.items['paid_radius'] != null ? int.parse(widget.items['paid_radius']) : 400;
    setState(() {
      if (!widget.isPurchased && widget.currentUser.maxDistance > freeR) {
        widget.currentUser.maxDistance = freeR.round();
        changeValues.addAll({'maximum_distance': freeR.round()});
      } else if (widget.isPurchased && widget.currentUser.maxDistance >= paidR) {
        widget.currentUser.maxDistance = paidR.round();
        changeValues.addAll({'maximum_distance': paidR.round()});
      }
      _showMe = widget.currentUser.showGender;
      distance = widget.currentUser.maxDistance.round();
      ageRange = RangeValues(double.parse(widget.currentUser.ageRange['min']),
          (double.parse(widget.currentUser.ageRange['max'])));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
          title: Text(
            "Ayarlar",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: primaryColor),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Hesap Ayarları",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  title: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Telefon Numarası"),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              widget.currentUser.phoneNumber != null
                                  ? "${widget.currentUser.phoneNumber}"
                                  : "Şimdi Doğrula",
                              style: TextStyle(color: secondryColor),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: secondryColor,
                            size: 15,
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => UpdateNumber(widget.currentUser))),
                    ),
                  )),
                  subtitle: Text("Verify a phone number to secure your account"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Keşfetme Ayarları",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    child: ExpansionTile(
                      key: UniqueKey(),
                      leading: Text("Konum"),
                      trailing: Text(
                        "Mevcut Konum",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text(""),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 25,
                              ),
                              InkWell(
                                child: Text(
                                  "Konumu değiştir",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () async {
                                  var currentLocation = await Geolocator()
                                      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                                  List<Placemark> pm = await Geolocator().placemarkFromCoordinates(
                                      currentLocation.latitude, currentLocation.longitude);
                                  var address =
                                      "${pm[0].locality}${pm[0].subLocality} ${pm[0].subAdministrativeArea}\n ${pm[0].country} ,${pm[0].postalCode}";
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (ctx) {
                                        return Container(
                                          color: Colors.white,
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height * .4,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Yeni adres:',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w300,
                                                      decoration: TextDecoration.none),
                                                ),
                                              ),
                                              Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(18.0),
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w300,
                                                        decoration: TextDecoration.none),
                                                  ),
                                                ),
                                              ),
                                              RaisedButton(
                                                color: Colors.white,
                                                child: Text(
                                                  "Bitti",
                                                  style: TextStyle(color: primaryColor),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Firestore.instance
                                                      .collection("Users")
                                                      .document('${widget.currentUser.id}')
                                                      .updateData({
                                                    'location': {
                                                      'latitude': currentLocation.latitude,
                                                      'longitude': currentLocation.longitude,
                                                      'address': address
                                                    },
                                                  });
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (_) {
                                                        Future.delayed(Duration(seconds: 3), () {
                                                          Navigator.pop(context);
                                                        });
                                                        return Center(
                                                            child: Container(
                                                                width: 160.0,
                                                                height: 120.0,
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
                                                                      "Konum\ndeğiştirldi.",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration.none,
                                                                          color: Colors.black,
                                                                          fontSize: 20),
                                                                    )
                                                                  ],
                                                                )));
                                                      });

                                                  // .then((_) {
                                                  //   Navigator.pop(context);
                                                  // });
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    "Diğer şehirdeki üyeleri görmek için konumunuzu değiştirin ",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Kimleri görmek istersin",
                            style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500),
                          ),
                          ListTile(
                            title: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Erkek"),
                                  value: "man",
                                ),
                                DropdownMenuItem(child: Text("Woman"), value: "woman"),
                                DropdownMenuItem(child: Text("Everyone"), value: "everyone"),
                              ],
                              onChanged: (val) {
                                changeValues.addAll({
                                  'showGender': val,
                                });
                                setState(() {
                                  _showMe = val;
                                });
                              },
                              value: _showMe,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          "Maximum Uzaklık",
                          style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                        trailing: Text(
                          "$distance Km.",
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Slider(
                            value: distance.toDouble(),
                            inactiveColor: secondryColor,
                            min: 1.0,
                            max: widget.isPurchased ? paidR.toDouble() : freeR.toDouble(),
                            activeColor: primaryColor,
                            onChanged: (val) {
                              changeValues.addAll({'maximum_distance': val.round()});
                              setState(() {
                                distance = val.round();
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          "Yaş aralığı",
                          style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                        trailing: Text(
                          "${ageRange.start.round()}-${ageRange.end.round()}",
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: RangeSlider(
                            inactiveColor: secondryColor,
                            values: ageRange,
                            min: 18.0,
                            max: 100.0,
                            divisions: 25,
                            activeColor: primaryColor,
                            labels: RangeLabels('${ageRange.start.round()}', '${ageRange.end.round()}'),
                            onChanged: (val) {
                              changeValues.addAll({
                                'age_range': {
                                  'min': '${val.start.truncate()}',
                                  'max': '${val.end.truncate()}'
                                }
                              });
                              setState(() {
                                ageRange = val;
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Uygulama Ayarları",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Bildirimler",
                              style:
                                  TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Bildirim gönder"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "Çıkış Yap",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Çıkış Yap'),
                            content: Text('Hesabınızı kapatmak istiyor musunuz?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Hayır'),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await _auth.signOut().whenComplete(() {
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(builder: (context) => Login()),
                                    );
                                  });
                                },
                                child: Text('Evet'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Center(
                          child: Text(
                            "Hesabı Sil",
                            style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Hesabı Sil'),
                            content: Text('Hesabınızı silmek istiyor musunuz? '),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Hayır'),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  final user = await _auth.currentUser().then((FirebaseUser user) {
                                    return user;
                                  });
                                  await _deleteUser(user).then((_) async {
                                    await _auth.signOut().whenComplete(() {
                                      Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(builder: (context) => Login()),
                                      );
                                    });
                                  });
                                },
                                child: Text('Evet'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Container(
                          height: 50,
                          width: 100,
                          child: Image.asset(
                            "asset/Icon/icon.png",
                            fit: BoxFit.contain,
                          )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _deleteUser(FirebaseUser user) async {
    await Firestore.instance.collection("Users").document(user.uid).delete();
  }
}
