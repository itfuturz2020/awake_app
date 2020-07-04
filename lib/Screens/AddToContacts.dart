import 'package:awake_app/Pages/ContactService.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class AddToContacts extends StatefulWidget {
  var Name, Mobile, Company, Email;

  AddToContacts({this.Name, this.Mobile, this.Company, this.Email});

  @override
  _AddToContactsState createState() => _AddToContactsState();
}

class _AddToContactsState extends State<AddToContacts> {
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
      contactName += "${widget.Name}";
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
                        initialValue: "${widget.Mobile}",
                        decoration: const InputDecoration(labelText: 'Phone'),
                        onSaved: (v) =>
                            contact.phones = [Item(label: "mobile", value: v)],
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        initialValue: widget.Email != null || widget.Email != ""
                            ? "${widget.Email}"
                            : "",
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        onSaved: (v) =>
                            contact.emails = [Item(label: "work", value: v)],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        initialValue:
                            widget.Company != null || widget.Company != ""
                                ? "${widget.Company}"
                                : "",
                        decoration: const InputDecoration(labelText: 'Company'),
                        onSaved: (v) => contact.company = v,
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
