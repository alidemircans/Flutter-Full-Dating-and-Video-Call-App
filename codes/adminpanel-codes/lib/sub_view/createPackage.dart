import 'package:flutter/material.dart';
import 'package:missyou_admin/color.dart';

class CreatePackage extends StatefulWidget {
  final Map index;
  final List<Map<String, dynamic>> productList;
  CreatePackage(this.index, this.productList);

  @override
  _CreatePackageState createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  @override
  void initState() {
    if (widget.index != null) {
      activate = widget.index['status'] ?? false;
      edit = true;
      idctlr.text = widget.index['id'] ?? "";
      titlectlr.text = widget.index['title'] ?? "";
      descctlr.text = widget.index['description'] ?? "";
    }
    if (mounted) setState(() {});
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> data = {};

  TextEditingController idctlr = TextEditingController();

  TextEditingController titlectlr = TextEditingController();

  TextEditingController descctlr = TextEditingController();

  bool edit = false;
  bool activate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                edit ? "Edit subscription" : "Add new subscription",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25, color: mainColor),
              ),
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context, null))),
          Positioned(
              bottom: 10,
              right: 10,
              child: RaisedButton(
                  color: mainColor,
                  child: Text(
                    edit ? "Save Changes" : "SAVE",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      data['status'] = activate;
                      Navigator.pop(context, data);
                    }
                  })),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 20, right: 100),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                dense: true,
                leading: Checkbox(
                    value: activate,
                    tristate: true,
                    activeColor: mainColor,
                    onChanged: (val) {
                      setState(() {
                        activate = !activate;
                        // widget.index["status"] = !widget.index["status"];
                      });
                    }),
                title: Text("Activate"),
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: titlectlr,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      cursorColor: mainColor,
                      decoration: InputDecoration(
                        helperText: "this is how it will appear in app",
                        labelText: "Title",
                        hintText: "Title",
                      ),
                      onSaved: (value) {
                        data['title'] = value;
                      },
                    ),
                    TextFormField(
                      controller: idctlr,
                      readOnly: edit,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter id';
                        } else if (data['id'] != null &&
                            widget.productList.any((element) => element['id'] == value)) {
                          return 'id already exist ';
                        }
                        return null;
                      },
                      cursorColor: mainColor,
                      decoration: InputDecoration(
                        helperText: "it should match with play console product id",
                        labelText: "Product id",
                        hintText: "Product id",
                      ),
                      onChanged: (value) {
                        data['id'] = value;
                      },
                    ),
                    TextFormField(
                      controller: descctlr,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      minLines: 2,
                      autofocus: false,
                      cursorColor: mainColor,
                      maxLines: 5,
                      decoration: InputDecoration(
                        helperText: "this is how it will appear in app",
                        labelText: "Description",
                        hintText: "Description",
                      ),
                      onSaved: (value) {
                        data['description'] = value;
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
