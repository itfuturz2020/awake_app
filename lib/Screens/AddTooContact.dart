import 'package:awake_app/Pages/ContactService.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class AddTooContact extends StatefulWidget {
  var memberData;

  AddTooContact({this.memberData});

  @override
  _AddTooContactState createState() => _AddTooContactState();
}

class _AddTooContactState extends State<AddTooContact> {
  Contact contact = Contact();
  PostalAddress address = PostalAddress(label: "ConclaveHome");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String contactName;

  @override
  void initState() {
    _getContactPermission();
    setState(() {
      contactName = "BNI ";
      /*widget.memberData["chapter"] != "null" || widget.memberData["chapter"] != ""
        ? contactName += widget.memberData["chapter"].toString().substring(0,1).toUpperCase() + " "
        : contactName += " ";*/
      contactName += "${widget.memberData["Name"]}";
    });
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.restricted) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("Data : ${widget.memberData}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Contact"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              print("name:" + contact.givenName.toString());
              _formKey.currentState.save();
              ContactService.addContact(contact);
              print(_formKey.toString());
              Fluttertoast.showToast(
                  msg: "Contact Saved Successfully...",
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_LONG);
              Navigator.of(context).pop();
            },
            child: Icon(Icons.save, color: Colors.white),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //padding: EdgeInsets.all(12.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: width * 0.15),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: "${contactName}",
                        decoration: const InputDecoration(labelText: "Name"),
                        onSaved: (v) {
                          setState(() {
                            contact.givenName = v;
                          });
                        },
                      ),
                      TextFormField(
                        initialValue: "${widget.memberData["MobileNo"]}",
                        decoration: const InputDecoration(labelText: 'Phone'),
                        onSaved: (v) =>
                            contact.phones = [Item(label: "mobile", value: v)],
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        initialValue: widget.memberData["Email"] != null ||
                                widget.memberData["Email"] != ""
                            ? "${widget.memberData["Email"]}"
                            : "",
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        onSaved: (v) =>
                            contact.emails = [Item(label: "work", value: v)],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        initialValue: widget.memberData["Company"] != null ||
                                widget.memberData["Company"] != ""
                            ? "${widget.memberData["Company"]}"
                            : "",
                        decoration: const InputDecoration(labelText: 'Company'),
                        onSaved: (v) => contact.company = v,
                      ),
                      TextFormField(
                        initialValue: widget.memberData["City"] != null ||
                                widget.memberData["City"] != ""
                            ? "${widget.memberData["City"]}"
                            : "",
                        decoration: const InputDecoration(labelText: 'Address'),
                        onSaved: (v) => address.city = v,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: width * 0.11,
                child: RaisedButton(
                  onPressed: () {
                    print("name:" + contact.givenName.toString());
                    _formKey.currentState.save();
                    ContactService.addContact(contact);
                    print(_formKey.toString());
                    Fluttertoast.showToast(
                        msg: "Contact Saved Successfully...",
                        gravity: ToastGravity.TOP,
                        toastLength: Toast.LENGTH_LONG);
                    Navigator.of(context).pop();
                  },
                  color: cnst.appPrimaryMaterialColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Save Contact to Phone",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
