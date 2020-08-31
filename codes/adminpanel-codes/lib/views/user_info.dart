import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou_admin/model/customAlert.dart';
import 'package:missyou_admin/model/user.dart';
import 'package:missyou_admin/views/login.dart';

class Info extends StatefulWidget {
  final User userIndex;
  Info(this.userIndex);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  bool isLargeScreen = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => (Navigator.pop(
              context,
              true,
            )),
          ),
          centerTitle: true,
          title: Text("${widget.userIndex.name}"),
          actions: [
            PopupMenuButton(itemBuilder: (ct) {
              return [
                PopupMenuItem(
                  enabled: true,
                  height: 20,
                  value: 1,
                  child: InkWell(
                    child: Text("${widget.userIndex.isBlocked ? "Unblock user" : "Block user"}"),
                    onTap: () async {
                      Navigator.pop(ct);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BeautifulAlertDialog(
                              text:
                                  "Do you want to ${widget.userIndex.isBlocked ? "Unblock" : "Block"} ${widget.userIndex.name} ?",
                              onYesTap: () async {
                                await Firestore.instance
                                    .collection("Users")
                                    .document(widget.userIndex.id)
                                    .updateData({
                                  "isBlocked": !widget.userIndex.isBlocked,
                                }).whenComplete(() {
                                  snackbar("${!widget.userIndex.isBlocked ? "Blocked" : "Unblocked"}",
                                      _scaffoldKey);
                                  widget.userIndex.isBlocked = !widget.userIndex.isBlocked;
                                });
                                Navigator.pop(context);
                              },
                              onNoTap: () => Navigator.pop(context));
                        },
                      );
                    },
                  ),
                )
              ];
            })
          ],
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: isLargeScreen ? const EdgeInsets.only(right: 50) : EdgeInsets.all(1),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: isLargeScreen
                        ? MediaQuery.of(context).size.width * .35
                        : MediaQuery.of(context).size.width * .45,
                    child: GridView.count(
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        //     MediaQuery.of(context).size.aspectRatio * .4,
                        crossAxisSpacing: 4,
                        padding: EdgeInsets.all(10),
                        children: List.generate(9, (index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      // widget.userIndex.imageUrl[0] != null
                                      //     ?
                                      Container(
                                    decoration: widget.userIndex.imageUrl.length > index &&
                                            widget.userIndex.imageUrl[index] != null
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            // image: DecorationImage(
                                            //     fit: BoxFit.cover,
                                            //     image: NetworkImage(
                                            //       widget.userIndex.imageUrl[index],
                                            //     )),
                                          )
                                        : BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                style: BorderStyle.solid, width: 1, color: Colors.grey),
                                          ),
                                    child: Stack(
                                      children: <Widget>[
                                        widget.userIndex.imageUrl.length > index &&
                                                widget.userIndex.imageUrl[index] != null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        widget.userIndex.imageUrl[index],
                                                      )),
                                                ),
                                              )
                                            : Container(),
                                        // Center(
                                        //     child: widget.userIndex.imageUrl.length >
                                        //                 index &&
                                        //             widget.userIndex
                                        //                     .imageUrl[index] ==
                                        //                 null
                                        //         ? CupertinoActivityIndicator(
                                        //             radius: 10,
                                        //           )
                                        //         : Container()),
                                      ],
                                    ),
                                  ))
                              //: Container()),
                              );
                        })),
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      title: Text("Username"),
                      subtitle: Text(widget.userIndex.name),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Gender"),
                      subtitle: Text(widget.userIndex.gender),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Phone Number"),
                      subtitle: Text(widget.userIndex.phoneNumber),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("age"),
                      subtitle: Text(widget.userIndex.age.toString()),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Maximum Distance"),
                      subtitle: Text(widget.userIndex.maxDistance.toString()),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("Age Range"),
                      subtitle: Text(widget.userIndex.ageRange.toString()),
                    ),

                    //  ListTile(
                    //   title: Text("User_id"),
                    //   subtitle: Text(widget.userIndex.id),
                    // ),
                  ],
                )),
                Expanded(
                    child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      dense: true,
                      title: Text("About"),
                      subtitle: Text(widget.userIndex.editInfo["about"] != null
                          ? widget.userIndex.editInfo["about"]
                          : "----"),
                    ),
                    ListTile(
                      dense: true,
                      title: Text("University"),
                      subtitle: Text(widget.userIndex.editInfo['university']),
                    ),
                    ListTile(
                        dense: true,
                        title: Text("Job title"),
                        subtitle: Text(widget.userIndex.editInfo["job_title"] != null
                            ? widget.userIndex.editInfo["job_title"]
                            : "----")),
                    ListTile(
                        dense: true,
                        title: Text("Company"),
                        subtitle: Text(widget.userIndex.editInfo["company"] != null
                            ? widget.userIndex.editInfo["company"]
                            : "----")),
                    ListTile(
                        dense: true,
                        title: Text("Living in"),
                        subtitle: Text(widget.userIndex.editInfo["living_in"] != null
                            ? widget.userIndex.editInfo["living_in"]
                            : "----")),
                    ListTile(
                      dense: true,
                      title: Text("Address"),
                      subtitle: Text(widget.userIndex.address),
                    ),
                  ],
                )),
              ],
            ),
          );
        }));
  }
}
