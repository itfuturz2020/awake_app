import 'package:avatar_glow/avatar_glow.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberProfileView extends StatefulWidget {
  var memberData;
  String image;

  MemberProfileView({this.memberData, this.image});

  @override
  _MemberProfileViewState createState() => _MemberProfileViewState();
}

class _MemberProfileViewState extends State<MemberProfileView> {
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();

  bool isLoading = true;
  ProgressDialog pr;
  String MemberId = "";

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
      if (widget.memberData["email"] != "") {
        edtEmail.text = widget.memberData["email"];
      } else {
        edtEmail.text = "E-mail Not Availble!";
      }
      if (widget.memberData["address"] != "") {
        edtAddress.text = widget.memberData["address"];
      } else {
        edtAddress.text = "Address Not Available!";
      }
    });
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Member = prefs.getString(Session.MemberId);

    setState(() {
      MemberId = Member;

      isLoading = false;
    });
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: "Link Not Found",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  static openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  _openWhatsapp(String mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Member Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? LoadingComponent()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          AvatarGlow(
                            startDelay: Duration(milliseconds: 1000),
                            glowColor: cnst.appPrimaryMaterialColor,
                            endRadius: 80.0,
                            duration: Duration(milliseconds: 2000),
                            repeat: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                child: Hero(
                                  tag: "${widget.memberData["MemberId"]}",
                                  child: ClipOval(
                                    child: widget.image != null &&
                                            widget.image != '' &&
                                            (widget.image
                                                    .toLowerCase()
                                                    .contains(".jpg") ||
                                                widget.image
                                                    .toLowerCase()
                                                    .contains(".jpeg") ||
                                                widget.image
                                                    .toLowerCase()
                                                    .contains(".png"))
                                        ? FadeInImage.assetNetwork(
                                            placeholder: 'assets/loading.gif',
                                            //image: '${widget.image}',
                                            image: widget.image
                                                    .toString()
                                                    .contains(IMG_URL)
                                                ? '${widget.image}'
                                                : IMG_URL + '${widget.image}',
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.fill,
                                          )
                                        : Container(
                                            decoration: new BoxDecoration(
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            width: 120,
                                            height: 120,
                                            child: Center(
                                                child: Text(
                                                    widget.memberData["name"] ==
                                                                "" ||
                                                            widget.memberData[
                                                                    "name"] ==
                                                                null
                                                        ? "?"
                                                        : "${widget.memberData["name"].toString().substring(0, 1).toUpperCase()}",
                                                    style: TextStyle(
                                                        fontSize: 36,
                                                        color: Colors.white))),
                                          ),
                                  ),
                                ),
                                radius: 50.0,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.memberData["name"]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          Text(
                            '${widget.memberData["companyname"]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          Text(
                            '${widget.memberData["categoryname"]}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          widget.memberData["IsPrivate"] != true
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.call,
                                                size: 35,
                                              ),
                                              onPressed: () {
                                                launch("tel:" +
                                                    widget.memberData["mobile"]
                                                        .toString());
                                              },
                                            ),
                                            Text('Call Us')
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _openWhatsapp(
                                                widget.memberData["mobile"]);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                'images/whatsapp.png',
                                                width: 48,
                                                height: 48,
                                              ),
                                              Text('Whatsapp')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                      right: 10,
                                      bottom: 10)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    widget.memberData["IsPrivate"] != true
                                        ? Row(
                                            children: <Widget>[
                                              SizedBox(
                                                child: TextFormField(
                                                  controller: edtEmail,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      labelText: "Email",
                                                      labelStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      hintText: "Email"),
                                                  enabled: false,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (widget.memberData["Email"]
                                                              .toString() ==
                                                          "" ||
                                                      widget.memberData["Email"]
                                                              .toString()
                                                              .toLowerCase() ==
                                                          "null") {
                                                    Fluttertoast.showToast(
                                                        msg: "Email Not Found.",
                                                        textColor:
                                                            cnst.appPrimaryMaterialColor[
                                                                700],
                                                        backgroundColor:
                                                            Colors.red,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT);
                                                  } else {
                                                    var url =
                                                        'mailto:${widget.memberData["Email"].toString()}?subject=&body=';
                                                    launch(url);
                                                  }
                                                },
                                                child: Image.asset(
                                                  'images/mail.png',
                                                  height: 22,
                                                  width: 32,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    TextFormField(
                                      controller: edtAddress,
                                      scrollPadding: EdgeInsets.all(0),
                                      decoration: InputDecoration(
                                          labelText: "Address",
                                          labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          hintText: "City"),
                                      enabled: false,
                                      maxLines: 4,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 0, bottom: 0),
                      height: 42,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(0))),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _launchURL("${widget.memberData["facebook"]}");
                            },
                            child: Container(
                              height: 42,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.indigo[100],
                              //color: Colors.blue[300],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Image.asset(
                                  'images/facebook.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL("${widget.memberData["instagram"]}");
                            },
                            child: Container(
                              height: 42,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.purple[100],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Image.asset(
                                  'images/instagram.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL("${widget.memberData["twitter"]}");
                            },
                            child: Container(
                              height: 42,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.blue[100],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Image.asset(
                                  'images/twitter.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL("${widget.memberData["linkedin"]}");
                            },
                            child: Container(
                              height: 42,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.indigo[100],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Image.asset(
                                  'images/linkedin.png',
                                  height: 15,
                                  width: 15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          /*GestureDetector(
                            onTap: () {
                              _launchURL(
                                  "${widget.memberData["facebook"]}");
                            },
                            child: Image.asset(
                              'images/facebook.png',
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  "${widget.memberData["instagram"]}");
                            },
                            child: Image.asset(
                              'images/instagram.png',
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  "${widget.memberData["twitter"]}");
                            },
                            child: Image.asset(
                              'images/twitter.png',
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(
                                  "${widget.memberData["linkedin"]}");
                            },
                            child: Image.asset(
                              'images/linkedin.png',
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            ),
                          )*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
