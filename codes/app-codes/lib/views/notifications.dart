import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou/views/Information.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';

class Notifications extends StatefulWidget {
  final User currentUser;
  final List notification;
  Notifications(this.currentUser, this.notification);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (widget.notification.length > 1) {
        widget.notification.sort((a, b) {
          var adate = a.time; //before -> var adate = a.expiry;
          var bdate = b.time; //before -> var bdate = b.expiry;
          return bdate.compareTo(adate); //to get the order other way just switch `adate & bdate`
        });
      }
    });
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Column(
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: Text(
                //     'this week',
                //     style: TextStyle(
                //       color: primaryColor,
                //       fontSize: 18.0,
                //       fontWeight: FontWeight.bold,
                //       letterSpacing: 1.0,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                      child: widget.notification.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.notification.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: !widget.notification[index].isRead
                                              ? primaryColor.withOpacity(.15)
                                              : secondryColor.withOpacity(.15)),
                                      child: widget.notification[index].time != null
                                          ? ListTile(
                                              contentPadding: EdgeInsets.all(5),
                                              leading: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: secondryColor,
                                                  backgroundImage: NetworkImage(
                                                    widget.notification[index].sender.imageUrl[0],
                                                  )),
                                              title: Text(
                                                  "${widget.notification[index].sender.name} ile eşleştin"),
                                              subtitle: Text("${(widget.notification[index].time.toDate())}"),
                                              //  Text(
                                              //     "Now you can start chat with ${notification[index].sender.name}"),
                                              // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    //  Text("${(notification[index].time).toDate()}"),
                                                    !widget.notification[index].isRead
                                                        ? Container(
                                                            width: 40.0,
                                                            height: 20.0,
                                                            decoration: BoxDecoration(
                                                              color: primaryColor,
                                                              borderRadius: BorderRadius.circular(30.0),
                                                            ),
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              'YENİ',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          )
                                                        : Text(""),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      if (!widget.notification[index].isRead) {
                                                        Firestore.instance
                                                            .collection(
                                                                "/Users/${widget.currentUser.id}/Matches")
                                                            .document(
                                                                '${widget.notification[index].sender.id}')
                                                            .updateData({'isRead': true});
                                                      }
                                                      return Info(widget.notification[index].sender,
                                                          widget.currentUser, null);
                                                    });
                                              },
                                            )
                                          : Container()),
                                );
                              })
                          : Center(
                              child: Text(
                              "No notification",
                              style: TextStyle(color: secondryColor, fontSize: 16),
                            ))),
                ),
              ],
            ),
          ),
        ));
  }
}
