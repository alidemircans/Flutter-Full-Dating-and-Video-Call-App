import 'package:flutter/material.dart';
import 'package:missyou/views/Chat/recent_chats.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';
import 'Matches.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;
  final List<User> matches;
  HomeScreen(this.currentUser, this.matches);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Matches(widget.currentUser, widget.matches),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Recent Messages',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  RecentChats(widget.currentUser, widget.matches),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
