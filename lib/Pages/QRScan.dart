import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/CardShareComponent.dart';
import 'package:awake_app/Screens/AddToContacts.dart';
import 'package:awake_app/offlinedatabase/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class QRScan extends StatefulWidget {
  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  bool isLoading;
  String qrData = '';
  String cardData;
  String memberId,
      name,
      mobile,
      company,
      category,
      email,
      type = "visitor",
      barcode;
  DBHelper dbHelper;
  ProgressDialog pr;
  String ShareMsg =
      "Hello sir,\n My Name is #sender. You can see my digital visiting card from the below link.\n #link \n Regards \n #sender \n Download the App from the below link to make sure your own visiting card. \n #applink";
  bool IsActivePayment = true;
  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    setState(() {
      dbHelper = new DBHelper();
    });
    _getLocalData();
  }

  _getViewCardId(String type) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile = prefs.getString(cnst.Session.mobile);
      setState(() {
        name = prefs.getString(cnst.Session.name);
      });
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getViewCardId(memberMobile);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              cardData = data;
              print("Card Id: ${cardData}");
            });
            if (type == "yes") {
              String profileUrl = cnst.profileUrl.replaceAll("#id", cardData);
              if (await canLaunch(profileUrl)) {
                await launch(profileUrl);
              } else {
                throw 'Could not launch $profileUrl';
              }
            }
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      memberId = prefs.getString(cnst.Session.MemberId);
      name = prefs.getString(cnst.Session.name);
      mobile = prefs.getString(cnst.Session.mobile);
      company = prefs.getString(cnst.Session.company);
      category = prefs.getString(cnst.Session.category);
      email = prefs.getString(cnst.Session.email);
    });

    setState(() {
      qrData = ((memberId != null ? memberId : '') +
          ',' +
          (name != null ? name : '') +
          ',' +
          (mobile != null ? mobile : '') +
          ',' +
          (company != null ? company : '') +
          ',' +
          (category != null ? category : '') +
          ',' +
          (email != null ? email : '') +
          ',' +
          type);
    });
    print(qrData);
  }

  sendVisitorDataToStall(String stallId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String MemberName = preferences.getString(Session.name);
        String MemberMobile = preferences.getString(Session.mobile);
        String MemberCompany = preferences.getString(Session.company);
        String MemberCategory = preferences.getString(Session.category);
        //String MemberAddress = preferences.getString(Session.city);
        String MemberEmail = preferences.getString(Session.email);

        _showStallDetails();
      } else {
        pr.hide();
        showMsg('no internet connection');
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _showStallDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Stall/Visitor Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 17,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Text(
                          "${name}",
                          style: TextStyle(
                              fontSize: 17,
                              color: cnst.appPrimaryMaterialColor,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: Text(
                      "Mobile",
                      style: TextStyle(
                          fontSize: 17,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "${mobile}",
                            style: TextStyle(
                                fontSize: 17,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: Text(
                      "Company",
                      style: TextStyle(
                          fontSize: 17,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: Text(
                      "${company}",
                      style: TextStyle(
                          fontSize: 17,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    )),
                  ),
                ],
              ),
              category != null
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Text(
                            "Category",
                            style: TextStyle(
                                fontSize: 17,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              child: Text(
                            "${category}",
                            style: TextStyle(
                                fontSize: 17,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      ],
                    )
                  : Container(),
              email != null
                  ? Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Text(
                            "E-mail",
                            style: TextStyle(
                                fontSize: 17,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              child: Text(
                            "${email}",
                            style: TextStyle(
                                fontSize: 17,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      ],
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GestureDetector(
                          onTap: () {
                            launch("tel://${mobile}");
                          },
                          child: Icon(
                            Icons.phone,
                            size: 25,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GestureDetector(
                        onTap: () {
                          _openWhatsApp("${mobile}");
                        },
                        child: Image.asset(
                          "images/whatsapp.png",
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GestureDetector(
                        onTap: () {
                          //launch("tel://${widget.data["Mobile"]}");
                          //print("${widget.data["VCF"]}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddToContacts(
                                        Name: name,
                                        Mobile: mobile,
                                        Company: company,
                                        Email: email,
                                      )));
                        },
                        child: Icon(
                          Icons.person_add,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Scan Again",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                scan();
              },
            ),
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                //Navigator.of(context).pop();
                //scan();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ConclaveDashboard', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  _openWhatsApp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      print("QR Text: ${barcode}");
      //&& qrtext.length > 2

      if (qrtext != null) {
        setState(() {
          memberId = qrtext[0].toString();
          name = qrtext[1].toString();
          mobile = qrtext[2].toString();
          company = qrtext[3].toString();
          category = qrtext[4].toString();
          email = qrtext[5].toString();
          //city = qrtext[6].toString();
          type = qrtext[6].toString();
          this.barcode = barcode;
        });
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            sendVisitorDataToStall(qrtext[0].toString());
          }
        } on SocketException catch (_) {
          print("insert in offline");
          await dbHelper.add(Visitorclass(
            int.parse(qrtext[0]),
            qrtext[1].toString(),
            qrtext[2].toString(),
            qrtext[3].toString(),
            qrtext[4].toString(),
            qrtext[5].toString(),
            qrtext[6].toString(),
          ));
          showMsg("Scanned Successfully");

          Future res = dbHelper.getVisitors();
          res.then((data) async {
            if (data != null && data.length > 0) {
              print(data[0].name);
            } else {}
          }, onError: (e) {
            print("Error $e");
          });
        }
        setState(() => this.barcode = barcode);
      } else {
        showMsg("Try Again.");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("BNI Evolve"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: new Wrap(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child: QrImage(
                    data: "${qrData}",
                    size: 230.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 35, left: 20, right: 20),
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  "Scan this QRCode to get contact information.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Container(
                height: 45,
                margin: EdgeInsets.only(bottom: 10, top: 20),
                child: MaterialButton(
                  color: cnst.appPrimaryMaterialColor,
                  onPressed: () {
                    //Navigator.pop(context);
                    scan();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Scan QRCode",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 35, left: 20, right: 20),
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  "Digital Card",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8.0, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 5,
                        textColor: Colors.white,
                        color: cnst.appPrimaryMaterialColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Share",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                            )
                          ],
                        ),
                        onPressed: () {
                          _getViewCardId("no");
                          bool val = true;
                          if (val != null && val == true)
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) =>
                                    CardShareComponent(
                                  memberId: cardData,
                                  memberName: name,
                                  isRegular: val,
                                  memberType: "",
                                  shareMsg: ShareMsg,
                                  IsActivePayment: IsActivePayment,
                                ),
                              ),
                            );
                          else
                            showMsg(
                                'Your trial is expired please contact to digital card team for renewal.\n\nThank you,\nRegards\nDigital Card');
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 5,
                        textColor: Colors.white,
                        color: cnst.appPrimaryMaterialColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("View Card",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                            )
                          ],
                        ),
                        onPressed: () async {
                          _getViewCardId("yes");
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
