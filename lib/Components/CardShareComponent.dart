import 'dart:io';

import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class CardShareComponent extends StatefulWidget {
  final String memberId;
  final String memberName;
  final bool isRegular;
  final String memberType;
  final String shareMsg;
  final bool IsActivePayment;

  const CardShareComponent(
      {Key key,
      this.memberId,
      this.memberName,
      this.isRegular,
      this.memberType,
      this.shareMsg,
      this.IsActivePayment})
      : super(key: key);

  @override
  _CardShareComponentState createState() => _CardShareComponentState();
}

class _CardShareComponentState extends State<CardShareComponent> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();

  String userMobile = '';

  MemberClass _memberClass;
  bool isLoading = true;

  String sender = "";
  Iterable<Contact> _contacts;

  @override
  void initState() {}

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Digital Card"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  SaveShare(String val, bool isurl) async {
    if (isurl == true)
      launch(val);
    else
      Share.share(val);

    var data = {
      'type': 'share',
      'name': txtName.text.trim(),
      'mobile': txtMobile.text.trim(),
      //'memberid': widget.memberId.toString(),
      'memberid':
          _memberClass != null ? _memberClass.memberId : widget.memberId,
    };
    print("Data: ${data}");
    Future res = Services.SaveShare(data);
    res.then((data) {
      if (data != null && data.ERROR_STATUS == false) {
        print("Share Saved");
      } else {
        print("Share Not Saved");
      }
      Navigator.pop(context);
    }, onError: (e) {
      print(e.toString());
      Navigator.pop(context);
    });
  }

  String ShareMessage(bool isurl) {
    String shareMessage = widget.shareMsg;
    String url = cnst.profileUrl;

    //Replace static string with userid
    if (_memberClass != null) {
      url = url.replaceAll("#id", _memberClass.memberId);
    } else {
      url = url.replaceAll("#id", widget.memberId);
    }

    //Replace static string with recever
    String urlwithrecever =
        shareMessage.replaceAll("#recever", txtName.text.trim());

    //Replace static string with Sender
    String urlwithsender =
        urlwithrecever.replaceAll("#sender", widget.memberName);

    //Replace static string with Link
    String urlwithprofilelink = isurl
        ? urlwithsender.replaceAll("#link", Uri.encodeComponent(url))
        : urlwithsender.replaceAll("#link", url);

    //Replace static string with Link
    String urlwithpapplink =
        urlwithprofilelink.replaceAll("#applink", cnst.playstoreUrl);

    if (widget.memberType == null ||
        widget.memberType.length == 0 ||
        widget.memberType == 'Trial')
      urlwithpapplink =
          urlwithpapplink + "\nPowered by ITFuturz, \nArpit Shah \n9879208321";

    return urlwithpapplink;
  }

  String DirectShareMessage() {
    String shareMessage = widget.shareMsg;
    String url = cnst.profileUrl;

    //Replace static string with userid
    if (_memberClass != null) {
      url = url.replaceAll("#id", _memberClass.memberId);
    } else {
      url = url.replaceAll("#id", widget.memberId);
    }

    //Replace static string with Sender
    String urlwithsender =
        shareMessage.replaceAll("#sender", widget.memberName);

    //Replace static string with Link
    String urlwithprofilelink = urlwithsender.replaceAll("#link", url);

    //Replace static string with Link
    String urlwithpapplink =
        urlwithprofilelink.replaceAll("#applink", cnst.playstoreUrl);

    if (widget.memberType == null ||
        widget.memberType.length == 0 ||
        widget.memberType == 'Trial')
      urlwithpapplink =
          urlwithpapplink + "\nPowered by ITFuturz, \nArpit Shah \n9879208321";

    return urlwithpapplink;
  }

  bool checkValidity(date) {
    if (date.trim() != null && date.trim() != "") {
      final f = new DateFormat('dd MMM yyyy');
      DateTime validTillDate = f.parse(date);
      print(validTillDate);
      DateTime currentDate = new DateTime.now();
      print(currentDate);
      if (validTillDate.isAfter(currentDate)) {
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.90),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.isRegular != null && widget.isRegular == true
                    ? Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextField(
                                controller: txtName,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.teal)),
                                    hintText: 'Name',
                                    labelText: 'Name',
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.green,
                                    ),
                                    suffixStyle:
                                        const TextStyle(color: Colors.green)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: txtMobile,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.teal)),
                                    hintText: 'Mobile',
                                    labelText: 'Mobile',
                                    prefixIcon: const Icon(
                                      Icons.phone_android,
                                      color: Colors.green,
                                    ),
                                    suffixStyle:
                                        const TextStyle(color: Colors.green)),
                              ),
                            ),
                            Platform.isAndroid
                                ? Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        MaterialButton(
                                          onPressed: () {
                                            print("Whatsapp Tap");
                                            if (txtName.text.trim() != null &&
                                                txtName.text.trim() != "" &&
                                                txtMobile.text.trim() != null &&
                                                txtMobile.text.trim() != "" &&
                                                txtMobile.text.trim().length ==
                                                    10) {
                                              String whatsAppLink =
                                                  cnst.whatsAppLink;
                                              String msg = ShareMessage(true);
                                              String urlwithmobile =
                                                  whatsAppLink.replaceAll(
                                                      "#mobile",
                                                      "91${txtMobile.text.trim()}");
                                              String urlwithmsg = urlwithmobile
                                                  .replaceAll("#msg", msg);
                                              SaveShare(urlwithmsg, true);
                                              //Share.share(urlwithmsg);

                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please fill all details",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.TOP,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            }
                                          },
                                          child: Image.asset(
                                            "images/whatsapp.png",
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.contain,
                                          ),
                                          minWidth: 30,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            if (txtName.text.trim() != null &&
                                                txtName.text.trim() != "" &&
                                                txtMobile.text.trim() != null &&
                                                txtMobile.text.trim() != "" &&
                                                txtMobile.text.trim().length ==
                                                    10) {
                                              String smsLink = cnst.smsLink;
                                              String msg = ShareMessage(true);

                                              String urlwithmobile =
                                                  smsLink.replaceAll("#mobile",
                                                      "91${txtMobile.text.trim()}");
                                              String urlwithmsg = urlwithmobile
                                                  .replaceAll("#msg", msg);
                                              Share.share(urlwithmsg);
                                              SaveShare(urlwithmsg, true);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please fill all details",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.TOP,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            }
                                          },
                                          child: Image.asset(
                                            "images/chat.png",
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.contain,
                                          ),
                                          minWidth: 30,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            if (txtName.text.trim() != null &&
                                                txtName.text.trim() != "" &&
                                                txtMobile.text.trim() != null &&
                                                txtMobile.text.trim() != "" &&
                                                txtMobile.text.trim().length ==
                                                    10) {
                                              String mailLink = cnst.mailLink;
                                              String msg = ShareMessage(true);

                                              String urlwithmail = mailLink
                                                  .replaceAll("#mail", "");
                                              String urlwithsubject =
                                                  urlwithmail.replaceAll(
                                                      "#subject",
                                                      "$sender Digital Card");
                                              String urlwithmsg = urlwithsubject
                                                  .replaceAll("#msg", msg);
                                              SaveShare(urlwithmsg, true);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please fill all details",
                                                  backgroundColor: Colors.red,
                                                  gravity: ToastGravity.TOP,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                            }
                                          },
                                          child: Image.asset(
                                            "images/mail.png",
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.contain,
                                          ),
                                          minWidth: 30,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  MaterialButton(
                                    onPressed: () async {
                                      if (txtName.text.trim() != null &&
                                          txtName.text.trim() != "" &&
                                          txtMobile.text.trim() != null &&
                                          txtMobile.text.trim() != "" &&
                                          txtMobile.text.trim().length == 10) {
                                        PermissionStatus permissionStatus =
                                            await _getContactPermission();
                                        try {
                                          if (permissionStatus ==
                                              PermissionStatus.granted) {
                                            Item item = Item(
                                                label: 'office',
                                                value: txtMobile.text
                                                    .trim()
                                                    .toString());

                                            Contact newContact = new Contact(
                                                givenName: txtName.text.trim(),
                                                phones: [item]);

                                            await ContactsService.addContact(
                                                newContact);
                                            Fluttertoast.showToast(
                                                msg: "Contact saved to phone",
                                                backgroundColor: Colors.green,
                                                gravity: ToastGravity.TOP,
                                                toastLength:
                                                    Toast.LENGTH_SHORT);
                                          } else {
                                            _handleInvalidPermissions(
                                                permissionStatus);
                                          }
                                        } catch (ex) {
                                          print(ex.toString());
                                          if (ex.toString() ==
                                              "PlatformException(PERMISSION_DENIED, Access to location data denied, null)") {
                                            showMsg(
                                                "Access permission is denied by user. \nplease go to setting -> app -> digitalcard -> permission, and allow permission");
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please fill all details",
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.TOP,
                                            toastLength: Toast.LENGTH_SHORT);
                                      }
                                    },
                                    shape: StadiumBorder(),
                                    color: cnst.appPrimaryMaterialColor,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.contact_phone,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text("Save contact",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    minWidth: 30,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      if (txtName.text.trim() != null &&
                                          txtName.text.trim() != "" &&
                                          txtMobile.text.trim() != null &&
                                          txtMobile.text.trim() != "" &&
                                          txtMobile.text.trim().length == 10) {
                                        String msg = ShareMessage(false);
                                        SaveShare(msg, false);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please fill all details",
                                            backgroundColor: Colors.red,
                                            gravity: ToastGravity.TOP,
                                            toastLength: Toast.LENGTH_SHORT);
                                      }
                                    },
                                    shape: StadiumBorder(),
                                    color: cnst.appPrimaryMaterialColor,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                              Platform.isAndroid
                                                  ? "More..."
                                                  : "Share",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    minWidth: 30,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: RawMaterialButton(
                                onPressed: () {
                                  String msg = DirectShareMessage();
                                  Share.share(msg);
                                  Navigator.pop(context);
                                },
                                splashColor: cnst.appPrimaryMaterialColor,
                                animationDuration: Duration(milliseconds: 100),
                                shape: StadiumBorder(),
                                elevation: 2,
                                fillColor: cnst.appPrimaryMaterialColor,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Share to existing Contact",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : widget.IsActivePayment == true
                        ? Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                    child: Image.asset('images/addmoney.png',
                                        height: 80, width: 80)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("Your trial is expired!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1)),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                        "you can pay online by clicking on bellow button",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0))),
                                MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 40,
                                  color: Colors.green,
                                  child: Text('Pay Online',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  padding: EdgeInsets.all(10),
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/Payment'),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                        "Or contact to digital card team for purchase / renewal.",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text("Arpit R Shah \n9879208321",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1)),
                                    GestureDetector(
                                        onTap: () {
                                          launch("tel:9879208321");
                                        },
                                        child: Icon(Icons.phone_in_talk,
                                            size: 40,
                                            color:
                                                cnst.appPrimaryMaterialColor))
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                        "Thank you,\nRegards\nDigital Card",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                    child: Image.asset('images/addmoney.png',
                                        height: 80, width: 80)),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                        "Contact to digital card team for purchase / renewal.",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text("Arpit R Shah \n9879208321",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1)),
                                    GestureDetector(
                                        onTap: () {
                                          launch("tel:9879208321");
                                        },
                                        child: Icon(Icons.phone_in_talk,
                                            size: 40,
                                            color:
                                                cnst.appPrimaryMaterialColor))
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                        "Thank you,\nRegards\nDigital Card",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: Colors.grey.shade700,
                    ),
                    minWidth: 30,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
