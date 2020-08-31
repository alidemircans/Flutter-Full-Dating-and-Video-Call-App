import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou/views/Payment/paymentDetails.dart';
import 'package:missyou/views/Payment/subscriptions.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
  String plan;

  final User currentUser;
  final bool isPuchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  IndexPage(this.currentUser, this.isPuchased, this.purchases, this.items, this.plan);
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  void _showModalSheet() {
    setState(() {
      widget.plan == null
          ? showModalBottomSheet(
              context: context,
              builder: (builder) {
                return Container(
                  child: Column(
                    children: [
                      Text(
                        "Sohbet Odasına katılmak için Premium Abone Olun",
                        style: TextStyle(color: Colors.black, fontSize: 36.0),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                  "ABONE OL",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                ))),
                            onTap: () {
                              if (widget.isPuchased && widget.purchases != null) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => PaymentDetails(widget.purchases)),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          Subscription(widget.currentUser, null, widget.items)),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(40.0),
                );
              })
          : onJoin();
    });
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty ? _validateError = true : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            role: _role,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Video Chat Room'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _channelController,
                    decoration: InputDecoration(
                      errorText: _validateError ? 'Enter password' : null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: 'Channel Password',
                    ),
                  ))
                ],
              ),
              Column(
                children: [
                  ListTile(
                    title: Text("Private Video Chat Room  "),
                    leading: Radio(
                      value: ClientRole.Broadcaster,
                      groupValue: _role,
                      onChanged: (ClientRole value) {
                        setState(() {
                          _role = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                          "JOIN THE CHAT",
                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                        ))),
                    onTap: _showModalSheet),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
