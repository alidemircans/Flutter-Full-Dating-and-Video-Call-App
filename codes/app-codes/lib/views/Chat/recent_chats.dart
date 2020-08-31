import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missyou/views/Chat/Matches.dart';
import 'package:missyou/views/Chat/chatPage.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';

class RecentChats extends StatelessWidget {
  final db = Firestore.instance;
  final User currentUser;
  final List<User> matches;

  RecentChats(this.currentUser, this.matches);

  String format(Duration duration) => duration.toString().split('.').first.padLeft(8, "0");
  @override
  Widget build(BuildContext context) {
    return
        // Expanded(
        //   child:
        SingleChildScrollView(
      child: Container(
        height: matches.length * 100.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: matches.length,
            itemBuilder: (BuildContext context, int index) {
              //final Message chat = chats[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ChatPage(
                      chatId: chatId(currentUser, matches[index]),
                      sender: currentUser,
                      second: matches[index],
                    ),
                  ),
                ),
                child: StreamBuilder(
                    stream: db
                        .collection("chats")
                        .document(chatId(currentUser, matches[index]))
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      else if (snapshot.data.documents.length == 0) {
                        return Container();
                      }
                      return Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: snapshot.data.documents[0]['sender_id'] != currentUser.id &&
                                  !snapshot.data.documents[0]['isRead']
                              ? primaryColor.withOpacity(.1)
                              : secondryColor.withOpacity(.2),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: secondryColor,
                                  radius: 30.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: CachedNetworkImage(
                                      imageUrl: matches[index].imageUrl[0],
                                      useOldImageOnUrlChange: true,
                                      placeholder: (context, url) => CupertinoActivityIndicator(
                                        radius: 15,
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      matches[index].name,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: Text(
                                        snapshot.data.documents[0]['image_url'].toString().length > 0
                                            ? "Resim"
                                            : snapshot.data.documents[0]['text'],
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data.documents[0]["time"] != null
                                      ? format(Duration(
                                          hours:
                                              Timestamp.fromDate(snapshot.data.documents[0]["time"].toDate())
                                                  .toDate()
                                                  .hour,
                                          minutes:
                                              Timestamp.fromDate(snapshot.data.documents[0]["time"].toDate())
                                                  .toDate()
                                                  .minute))
                                      : "",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                snapshot.data.documents[0]['sender_id'] != currentUser.id &&
                                        !snapshot.data.documents[0]['isRead']
                                    ? Container(
                                        width: 40.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Yeni',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Text(''),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}
