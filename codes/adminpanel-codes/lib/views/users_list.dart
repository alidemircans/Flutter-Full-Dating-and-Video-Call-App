import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missyou_admin/sub_view/settings.dart';
import 'package:missyou_admin/color.dart';
import 'package:missyou_admin/model/customAlert.dart';
import 'package:missyou_admin/model/user.dart';
import 'package:missyou_admin/views/change_password.dart';
import 'package:missyou_admin/views/user_info.dart';
import 'package:missyou_admin/sub_view/package.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  CollectionReference collectionReference = Firestore.instance.collection("Users");
  @override
  void initState() {
    _getuserList();
    super.initState();
  }

  TextEditingController searchctrlr = TextEditingController();
  bool isLargeScreen = false;

  int totalDoc;
  DocumentSnapshot lastVisible;
  int documentLimit = 25;
  List<User> user = [];
  bool sort = true;
  Future _getuserList() async {
    collectionReference.orderBy("userId", descending: false).getDocuments().then((value) {
      totalDoc = value.documents.length;
    });
    if (lastVisible != null) {
      await collectionReference
          .orderBy("userId", descending: false)
          .startAfterDocument(lastVisible)
          .limit(documentLimit)
          .getDocuments()
          .then((value) {
        if (value.documents.length < 1) {
          print("no more data");
          return;
        }
        lastVisible = value.documents[value.documents.length - 1];
        for (var doc in value.documents) {
          if (doc.data.length > 4) {
            User temp = User.fromDocument(doc);
            user.add(temp);
          }
        }
      });
      if (mounted) setState(() {});
    } else {
      await collectionReference
          .orderBy('userId', descending: false)
          .limit(documentLimit)
          .getDocuments()
          .then((value) {
        lastVisible = value.documents[value.documents.length - 1];
        for (var doc in value.documents) {
          if (doc.data.length > 4) {
            User temp = User.fromDocument(doc);
            user.add(temp);
          }
        }
      });
      if (mounted) setState(() {});
    }
  }

  Widget userlists(List<User> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: sort,
                  sortColumnIndex: 2,
                  columnSpacing: MediaQuery.of(context).size.width * .085,
                  columns: [
                    DataColumn(
                      label: Text("Images"),
                    ),
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                        label: Text("Gender"),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });
                          onSortColum(columnIndex, ascending);
                        }),
                    DataColumn(label: Text("Phone Number")),
                    DataColumn(label: Text("User_id")),
                    DataColumn(label: Text("view")),
                  ],
                  rows: list
                      .map(
                        (index) => DataRow(cells: [
                          DataCell(
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CircleAvatar(
                                child: index.imageUrl[0] != null
                                    ? Image.network(
                                        index.imageUrl[0],
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                                backgroundColor: Colors.grey,
                                radius: 18,
                              ),
                            ),
                            // onTap: () {
                            //   // write your code..
                            // },
                          ),
                          DataCell(
                            Text(index.name),
                          ),
                          DataCell(
                            Text(index.gender),
                          ),
                          DataCell(
                            Text(index.phoneNumber),
                          ),
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(
                                    index.id,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.content_copy,
                                      size: 20,
                                    ),
                                    tooltip: "copy",
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                        text: index.id,
                                      ));
                                    })
                              ],
                            ),
                          ),
                          DataCell(
                            IconButton(
                                icon: Icon(Icons.fullscreen),
                                tooltip: "open profile",
                                onPressed: () => Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Info(index)))),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
            searchReasultfuture != null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("1-${list.length} of $totalDoc  "),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  _getuserList().then((value) => Navigator.pop(context));
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ));
                                });
                          },
                        )
                      ],
                    ),
                  )
          ],
        ));
  }

  List<User> results = [];
  Future<QuerySnapshot> searchReasultfuture;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  searchuser(String query) {
    if (query.trim().length > 0) {
      Future<QuerySnapshot> users = collectionReference
          .where(
            isNumeric(query) ? 'phoneNumber' : 'UserName',
            isEqualTo: query,
          )
          .getDocuments();

      setState(() {
        searchReasultfuture = users;
      });
    }
  }

  Widget buildSearchresults() {
    return FutureBuilder(
      future: searchReasultfuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  mainColor,
                )),
              ),
              Text("Searching......"),
            ],
          );
          //
        }
        if (snapshot.data.documents.length > 0) {
          results.clear();
          snapshot.data.documents.forEach((DocumentSnapshot doc) {
            if (doc.data.length > 5) {
              User usert2 = User.fromDocument(doc);
              results.add(usert2);
            }
          });
          return userlists(results);
        }
        return Center(child: Text("no data found"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {},
        child: OrientationBuilder(builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Admin Panel',
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: mainColor,
                    ),
                  ),
                  ListTile(
                    trailing: Icon(
                      Icons.format_list_numbered,
                      color: mainColor,
                    ),
                    title: Text('PACKAGES'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Package()));
                    },
                  ),
                  Divider(
                    thickness: .5,
                    color: Colors.black,
                  ),
                  ListTile(
                    trailing: Icon(
                      Icons.storage,
                      color: mainColor,
                    ),
                    title: Text('ITEM ACCESS'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => SubscriptionSettings()));
                    },
                  ),
                  Divider(
                    thickness: .5,
                    color: Colors.black,
                  ),
                  ListTile(
                    trailing: Icon(
                      Icons.lock_open,
                      color: mainColor,
                    ),
                    title: Text('CHANGE ID/PASSWORD'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeIdPassword()));
                    },
                  ),
                  Divider(
                    thickness: .5,
                    color: Colors.black,
                  ),
                  ListTile(
                    trailing: Icon(
                      Icons.power_settings_new,
                      color: mainColor,
                    ),
                    title: Text('LOGOUT'),
                    onTap: () async {
                      _alertDialog(context);
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: mainColor,
              centerTitle: true,
              title: Text(
                "Users",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.white)),
                    height: 4,
                    width: isLargeScreen
                        ? MediaQuery.of(context).size.width * .3
                        : MediaQuery.of(context).size.width * .5,
                    child: Card(
                      child: TextFormField(
                        cursorColor: mainColor,
                        controller: searchctrlr,
                        decoration: InputDecoration(
                          hintText: "Search user",
                          filled: true,
                          prefixIcon: IconButton(
                              color: mainColor,
                              icon: Icon(Icons.search),
                              onPressed: () => searchuser(searchctrlr.text)),
                          suffixIcon: IconButton(
                            color: mainColor,
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchctrlr.clear();
                              setState(
                                () {
                                  searchReasultfuture = null;
                                },
                              );
                            },
                          ),
                        ),
                        onFieldSubmitted: searchuser,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: searchReasultfuture == null
                ? user.length > 0
                    ? userlists(user)
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                        mainColor,
                      )))
                : buildSearchresults(),
          );
        }));
  }

  void logout() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('isAuth', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  _alertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BeautifulAlertDialog(
            text: "Do you want to logout ?", onYesTap: logout, onNoTap: () => Navigator.pop(context));
      },
    );
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 2) {
      if (ascending) {
        user.sort((a, b) => a.gender.compareTo(b.gender));
      } else {
        user.sort((a, b) => b.gender.compareTo(a.gender));
      }
    }
  }
}
