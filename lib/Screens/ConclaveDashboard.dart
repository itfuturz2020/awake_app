import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/CardShareComponent.dart';
import 'package:awake_app/Pages/ConclaveHome.dart';
import 'package:awake_app/Pages/Events.dart';
import 'package:awake_app/Pages/OneTwoOneWithED.dart';
import 'package:awake_app/Pages/QRScan.dart';
import 'package:awake_app/Pages/SuccessStories.dart';
import 'package:awake_app/Screens/AddToContacts.dart';
import 'package:awake_app/Screens/AnimatedBottomBar.dart';
import 'package:awake_app/offlinedatabase/db_handler.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ConclaveDashboard extends StatefulWidget {
  @override
  _ConclaveDashboardState createState() => _ConclaveDashboardState();
}

class _ConclaveDashboardState extends State<ConclaveDashboard> {
  bool isLoading = false;
  int _currentIndex = 0;
  List<BarItem> barItems = [];
  String stallId,
      vistorName,
      mobile,
      company,
      category,
      email,
      Id,
      city,
      type = 'visitor';
  String barcode = "";
  ProgressDialog pr;
  List UserData = [];
  String memberName = "", memberEmail = "", memberCompanyName = "";
  String cardData;
  String memberId = '',
      name1 = "",
      mobile1 = "",
      company1 = "",
      category1 = "",
      email1 = "";
  String name = '';
  String qrData = '';

  String memberId1 = "";
  String MemberId = "";

  String MemberType = "";
  String ShareMsg =
      "Hello sir,\n My Name is #sender. You can see my digital visiting card from the below link.\n #link \n Regards \n #sender \n Download the App from the below link to make sure your own visiting card. \n #applink";
  bool IsActivePayment = true;

  DBHelper dbHelper;
  Future<List<Visitorclass>> visitor;
  static String isOnline;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      dbHelper = new DBHelper();
    });
    _getLocalData();

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
    _configureNotification();
  }

  _configureNotification() async {
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) async {
        print("FFFFFFFF" + data.toString());
        await saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      await saveDeviceToken();
    }
  }

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      var tokendata = token.split(':');
      setState(() {
        fcmToken = token;
        sendFCMTokan(token);
      });
      print("FCM Token : $fcmToken");
    });
  }

  sendFCMTokan(var FcmToken) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(FcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  List<String> titleList = [
    "BIB Evolve",
    "Events",
    "QR Scan",
    "Success Stories",
    "1-2-1 with ED",
  ];

  final List<Widget> _children = [
    ConclaveHome(),
    Events(),
    QRScan(),
    SuccessStories(),
    OneTwoOneWithED(),
  ];

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      memberName = prefs.getString(cnst.Session.name);
      memberEmail = prefs.getString(cnst.Session.email);
      memberCompanyName = prefs.getString(cnst.Session.company);
      memberId1 = prefs.getString(cnst.Session.MemberId);
      name1 = prefs.getString(cnst.Session.name);
      mobile1 = prefs.getString(cnst.Session.mobile);
      company1 = prefs.getString(cnst.Session.company);
      category1 = prefs.getString(cnst.Session.category);
      email1 = prefs.getString(cnst.Session.email);
      isOnline = prefs.getString(cnst.Session.isOnline);
    });
    if (prefs.getString(Session.isData) == 'true') {
      getLocalData();
    }

    setState(() {
      qrData = ((memberId1 != null ? memberId1 : '') +
          ',' +
          (name1 != null ? name1 : '') +
          ',' +
          (mobile1 != null ? mobile1 : '') +
          ',' +
          (company1 != null ? company1 : '') +
          ',' +
          (category1 != null ? category1 : '') +
          ',' +
          (email1 != null ? email1 : '') +
          ',' +
          (type != null ? type : ''));
    });
    print(qrData);
  }

  getLocalData() async {
    Future res = dbHelper.getVisitors();
    await res.then((data) async {
      if (data != null && data.length > 0) {
        setState(() {
          sendVisitedDataList(data);
        });
      }
    }, onError: (e) {
      print("Error $e");
    });
  }

  sendVisitedDataList(data) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String MemberName = prefs.getString(Session.name);
        String MemberMobile = prefs.getString(Session.mobile);
        String MemberCompany = prefs.getString(Session.company);
        String MemberCategory = prefs.getString(Session.category);
        String MemberEmail = prefs.getString(Session.email);

        for (int i = 0; i < data.length; i++) {
          Services.sendVisitorData(
                  "${data[i].id}",
                  MemberName,
                  MemberMobile,
                  MemberCompany,
                  MemberCategory,
                  MemberEmail,
                  "${data[i].type}",
                  mobile)
              .then((data) async {
            if (data.ERROR_STATUS == false) {
              dbHelper.delete();
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showMsg("Try Again");
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var qrtext = barcode.toString().split(",");
      print("QR Text: ${barcode}");
      //&& qrtext.length > 2

      if (qrtext != null) {
        setState(() {
          Id = qrtext[0].toString();
          vistorName = qrtext[1].toString();
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

  _openWhatsApp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
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

        //sendVisitorDataPost
        Future res = Services.sendVisitorData(Id, MemberName, MemberMobile,
            MemberCompany, MemberCategory, MemberEmail, type, mobile);
        res.then((data) async {
          pr.hide();
          if (data.ERROR_STATUS == false) {
            //signUpDone("Attendance Send Successfully");
            print("Scanned Data: ${data}");
            _showStallDetails();
          } else {
            pr.hide();
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        pr.hide();
        showMsg('no internet connection');
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
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

  _deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("BNI Conclave"),
          content: new Text("Are You Sure You Want To LogOut ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                _deleteData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ConclaveLogin', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
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
                          "${vistorName}",
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
                                        Name: vistorName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleList[_currentIndex].toString()),
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _settingModalBottomSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Image.asset(
                'images/icon_scanner.png',
                height: 40,
                width: 40,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showConfirmDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _children[_currentIndex],
      /*   bottomNavigationBar: AnimatedBottomBar(
        barItems: barItems,
        animationDuration: Duration(milliseconds: 350),
        onBarTab: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),*/
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          activeColor: cnst.appPrimaryMaterialColor,
          color: cnst.appPrimaryMaterialColor[300],
          initialActiveIndex: _currentIndex,
          height: 60,
          top: -30,
          curveSize: 100,
          style: TabStyle.fixedCircle,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            TabItem(icon: Icons.home),
            TabItem(
              icon: Icons.event,
            ),
            TabItem(icon: Icons.scanner),
            TabItem(icon: Icons.note),
            TabItem(icon: Icons.swap_horizontal_circle),
          ],
          backgroundColor: Colors.white,
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Container(
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          child: DrawerHeader(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacementNamed(
                                          context, '/ConclaveProfile');
                                    },
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2, top: 8),
                                            child: Text('${memberName}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    letterSpacing: 0.3)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text('${memberEmail}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    letterSpacing: 0.3)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text('${memberCompanyName}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    letterSpacing: 0.3)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //denish ubhal
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacementNamed(
                                        context, '/ConclaveProfile');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Image.asset(
                                      'images/icon_scanner.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: cnst.appPrimaryMaterialColor),
                          ),
                        ),
                      ],
                    ),
                    /*ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Events Schedule',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveEvents');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),*/
                    /*ListTile(
                      leading: Image.asset(
                        "images/handshake.png",
                        height: 27,
                        width: 27,
                        fit: BoxFit.fill,
                        color: Colors.black,
                      ),
                      title: Text(
                        '1-2-1 Invitation',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveOneTwoOne');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),*/
                    /* ListTile(
                      leading: Image.asset(
                        "images/biosheet.png",
                        height: 27,
                        width: 27,
                        fit: BoxFit.fill,
                      ),
                      title: Text(
                        'Bio Sheet',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/BioSheet');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),*/
                    /* ListTile(
                      leading: Icon(
                        Icons.library_books,
                        color: Colors.black,
                      ),
                      title: Text(
                        'BNI Members',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveDirectory');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Feature Presentation',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveCommittee');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person_outline,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Success Stories',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveSpeakerList');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.library_books,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Achievements',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveSponsor');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.supervisor_account,
                        color: Colors.black,
                      ),
                      title: Text('Training'),
                      //trailing:
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveBarterPartner');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.group,
                        color: Colors.black,
                      ),
                      title: Text('Corporate Empanelment'),
                      //trailing:
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(
                            context, '/ConclaveCorporateEmpanellment');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.local_dining,
                        color: Colors.black,
                      ),
                      title: Text('Food Stalls'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/ConclaveFoodStall');
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.feedback,
                        color: Colors.black,
                      ),
                      title: Text('Feedback'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, "/FeedbackScreen");
                      },
                    ),*/

                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      title: Text('Logout'),
                      onTap: () async {
                        _showConfirmDialog();
                        /*Navigator.of(context).pop();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.pushReplacementNamed(
                            context, "/ConclaveLogin");*/
                      },
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Container(
                // This align moves the children to the bottom
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Mobile App Developed by - IT Futurz.',
                          style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
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
                      margin: EdgeInsets.only(top: 15),
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    margin: EdgeInsets.only(bottom: 10),
                    child: MaterialButton(
                      color: cnst.appPrimaryMaterialColor,
                      onPressed: () {
                        //Navigator.pop(context);
                        scan();
                      },
                      child: Text(
                        "Scan QRCode",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
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
                                      pageBuilder:
                                          (BuildContext context, _, __) =>
                                              CardShareComponent(
                                        memberId: cardData,
                                        memberName: name,
                                        isRegular: val,
                                        memberType: MemberType,
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
                                  borderRadius:
                                      new BorderRadius.circular(30.0))),
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
                                  borderRadius:
                                      new BorderRadius.circular(30.0))),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 27;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 20, color: color);
  }
}
