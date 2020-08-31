import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:missyou/views/Chat/Matches.dart';
import 'package:missyou/views/Profile/EditProfile.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';
import 'package:swipe_stack/swipe_stack.dart';

import 'Chat/chatPage.dart';

class Info extends StatelessWidget {
  final User currentUser;
  final User user;

  final GlobalKey<SwipeStackState> swipeKey;
  Info(
    this.user,
    this.currentUser,
    this.swipeKey,
  );

  @override
  Widget build(BuildContext context) {
    bool isMe = user.id == currentUser.id;
    bool isMatched = swipeKey == null;
    //  if()

    //matches.any((value) => value.id == user.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      key: UniqueKey(),
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        return user.imageUrl.length != null
                            ? Hero(
                                tag: "abc",
                                child: CachedNetworkImage(
                                  imageUrl: user.imageUrl[index2],
                                  fit: BoxFit.cover,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) => CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              )
                            : Container();
                      },
                      itemCount: user.imageUrl.length,
                      pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              activeSize: 13, color: secondryColor, activeColor: primaryColor)),
                      control: new SwiperControl(
                        color: primaryColor,
                        disableColor: secondryColor,
                      ),
                      loop: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            subtitle: Text("${user.address}"),
                            title: Text(
                              "${user.name}, ${user.editInfo['showMyAge'] != null ? !user.editInfo['showMyAge'] ? user.age : "" : user.age}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            trailing: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: primaryColor,
                                )),
                          ),
                          user.editInfo['job_title'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.work, color: primaryColor),
                                  title: Text(
                                    "${user.editInfo['job_title']}${user.editInfo['company'] != null ? ' at ${user.editInfo['company']}' : ''}",
                                    style: TextStyle(
                                        color: secondryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['university'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.stars, color: primaryColor),
                                  title: Text(
                                    "${user.editInfo['university']}",
                                    style: TextStyle(
                                        color: secondryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['living_in'] != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.home, color: primaryColor),
                                  title: Text(
                                    "Yaşadığı yer : ${user.editInfo['living_in']} ",
                                    style: TextStyle(
                                        color: secondryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          !isMe
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: primaryColor,
                                  ),
                                  title: Text(
                                    "${user.editInfo['DistanceVisible'] != null ? user.editInfo['DistanceVisible'] ? 'Less than ${user.distanceBW} KM away' : 'Distance not visible' : 'Less than ${user.distanceBW} KM away'}",
                                    style: TextStyle(
                                        color: secondryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  user.editInfo['about'] != null
                      ? Text(
                          "${user.editInfo['about']}",
                          style: TextStyle(color: secondryColor, fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      : Container(),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            !isMatched
                ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey.currentState.swipeLeft();
                              }),
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.lightBlueAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey.currentState.swipeRight();
                              }),
                        ],
                      ),
                    ),
                  )
                : isMe
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                ),
                                onPressed: () => Navigator.push(
                                    context, CupertinoPageRoute(builder: (context) => EditProfile(user))))),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.message,
                                  color: primaryColor,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ChatPage(
                                              sender: currentUser,
                                              second: user,
                                              chatId: chatId(user, currentUser),
                                            ))))),
                      )
          ],
        ),
      ),
    );
  }
}
