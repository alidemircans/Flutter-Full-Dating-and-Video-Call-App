import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missyou_admin/sub_view/createPackage.dart';
import 'package:missyou_admin/color.dart';
import 'package:missyou_admin/model/customAlert.dart';
import 'package:missyou_admin/views/login.dart';
import 'dart:core';

class Package extends StatefulWidget {
  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  final collectionReference = Firestore.instance.collection("Packages");
  List<Map<String, dynamic>> products = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _getPackages();
    super.initState();
  }

  _getPackages() async {
    collectionReference.orderBy('timestamp', descending: false).snapshots().listen((doc) {
      products.clear();
      for (var item in doc.documents) {
        products.add(item.data);
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text("Manage Packages"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: OutlineButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: mainColor,
                    textDirection: TextDirection.rtl,
                  ),
                  label: Text("Create new"),
                  onPressed: () async {
                    if (products.length < 6) {
                      Map<String, dynamic> result = await Navigator.push(
                          context, MaterialPageRoute(builder: (context) => CreatePackage(null, products)));
                      // await showDialog(
                      //     barrierDismissible: false,
                      //     context: (context),
                      //     builder: (context) {
                      //       return Dialog(
                      //           // insetPadding: EdgeInsets.symmetric(
                      //           //     vertical: 50, horizontal: 150),
                      //           child: CreatePackage(null, products));
                      //     });

                      if (result != null) {
                        result['timestamp'] = FieldValue.serverTimestamp();
                        await collectionReference.document(result['id']).setData(result, merge: true);
                      }
                    } else {
                      snackbar("You have created already max number of packages", _scaffoldKey);
                    }
                  }),
            ),
          ),
        ],
      ),
      body: products.length > 0
          ? productlist(products)
          : Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
              mainColor,
            ))),
    );
  }

  Widget productlist(List<Map<String, dynamic>> list) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width * .08,
                  headingRowHeight: 40,
                  horizontalMargin: MediaQuery.of(context).size.width * .05,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Sr.No.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Product id",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Title",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      "Description",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Status",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Edit/Deactivate",
                      textAlign: TextAlign.center,
                    )),
                    DataColumn(
                        label: Text(
                      "Remove",
                      textAlign: TextAlign.center,
                    )),
                  ],
                  rows: list
                      .mapIndexed(
                        (index, i) => DataRow(cells: [
                          DataCell(
                            Text(
                              (i + 1).toString(),
                              //  products.indexOf(index).toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              index['id'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              index['title'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(
                              index["description"],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    index['status'] ? "Active" : "Deactivated",
                                    style: TextStyle(color: index['status'] ? Colors.green : Colors.red),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                index['status']
                                    ? Icon(
                                        Icons.done_outline,
                                        color: Colors.green,
                                        size: 13,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 13,
                                      ),
                              ],
                            ),
                          ),
                          DataCell(
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  Map editDetails = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreatePackage(index, products)));
                                  if (editDetails != null) {
                                    collectionReference.document(index['id']).updateData(editDetails);
                                    // setState(() {

                                    //   index.updateAll(
                                    //       (key, value) => editDetails[key]);
                                    // });
                                  }
                                }),
                          ),
                          DataCell(
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BeautifulAlertDialog(
                                          text: "Do you want to delete this package ?",
                                          onYesTap: () async {
                                            await collectionReference
                                                .document(index['id'])
                                                .delete()
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                            }).catchError((onError) {
                                              snackbar(onError, _scaffoldKey);
                                            }).then((value) =>
                                                    snackbar("Deleted Successfully", _scaffoldKey));
                                          },
                                          onNoTap: () => Navigator.pop(context));
                                    },
                                  );
                                }),
                          ),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ));
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T f(E e, int i)) {
    var i = 0;
    return this.map((e) => f(e, i++));
  }
}
