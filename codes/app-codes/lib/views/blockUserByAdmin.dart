import 'package:flutter/material.dart';
import 'package:missyou/util/color.dart';

class BlockUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondryColor.withOpacity(.5),
      body: AlertDialog(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Colors.white,
        actions: [
          Text("İtiraz Etmek İçin : missyou@fastservice.com"),
        ],
        title: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                      height: 50,
                      width: 100,
                      child: Image.asset(
                        "asset/Icon/icon.png",
                        fit: BoxFit.contain,
                      )),
                )),
            Text(
              "Üzgünüm, uygulamaya erişemezsiniz!",
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        content:
            Text("Yönetici tarafından engellenirsiniz ve profiliniz diğer kullanıcılar için de görünmez."),
      ),
    );
  }
}
