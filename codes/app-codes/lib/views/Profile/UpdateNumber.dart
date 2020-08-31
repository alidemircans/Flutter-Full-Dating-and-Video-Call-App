import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou/views/auth/otp.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';

class UpdateNumber extends StatelessWidget {
  final User currentUser;
  UpdateNumber(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          "Telefon Numarası Ayarları",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Telefon numarası", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Card(
                child: ListTile(
              title: Text(
                  currentUser.phoneNumber != null
                      ? "${currentUser.phoneNumber}"
                      : "Telefon numarasını doğrulayın",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              trailing: Icon(
                currentUser.phoneNumber != null ? Icons.done : null,
                color: primaryColor,
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("Doğrulanmış telefon numarası",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: secondryColor)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("Telefon numaranı güncelle",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primaryColor)),
                    ),
                  ),
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => OTP(true))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
