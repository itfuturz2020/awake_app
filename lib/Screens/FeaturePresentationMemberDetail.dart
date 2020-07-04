import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class FeaturePresentationMemberDetail extends StatefulWidget {
  var MemberId;
  FeaturePresentationMemberDetail(this.MemberId);
  @override
  _FeaturePresentationMemberDetailState createState() =>
      _FeaturePresentationMemberDetailState();
}

class _FeaturePresentationMemberDetailState
    extends State<FeaturePresentationMemberDetail> {
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  bool isLoading = true;
  List memberData = [];
  @override
  void initState() {
    _getMemberDetail();
  }

  _openWhatsapp(String mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  _getMemberDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetFeaturedMember(widget.MemberId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              memberData = data;
              isLoading = false;

              if (memberData[0]["Email"] != "") {
                edtEmail.text = memberData[0]["Email"];
              } else {
                edtEmail.text = "E-mail Not Availble!";
              }
              if (memberData[0]["Address"] != "") {
                edtAddress.text = memberData[0]["Address"];
              } else {
                edtAddress.text = "Address Not Available!";
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Chapter Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
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

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Member Detail"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
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
                              tag: "${memberData[0]["Id"]}",
                              child: ClipOval(
                                child: memberData[0]["Image"] != null &&
                                        memberData[0]["Image"] != '' &&
                                        (memberData[0]["Image"]
                                                .toLowerCase()
                                                .contains(".jpg") ||
                                            memberData[0]["Image"]
                                                .toLowerCase()
                                                .contains(".jpeg") ||
                                            memberData[0]["Image"]
                                                .toLowerCase()
                                                .contains(".png"))
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'assets/loading.gif',
                                        //image: '${memberData[0]["Image"]}',
                                        image: memberData[0]["Image"]
                                                .toString()
                                                .contains(IMG_URL)
                                            ? '${memberData[0]["Image"]}'
                                            : IMG_URL +
                                                '${memberData[0]["Image"]}',
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(
                                        decoration: new BoxDecoration(
                                            color: cnst.appPrimaryMaterialColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        width: 120,
                                        height: 120,
                                        child: Center(
                                            child: Text(
                                                memberData[0]["Name"] == "" ||
                                                        memberData[0]["Name"] ==
                                                            null
                                                    ? "?"
                                                    : "${memberData[0]["Name"].toString().substring(0, 1).toUpperCase()}",
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
                        '${memberData[0]["Name"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      Text(
                        '${memberData[0]["Company"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      Text(
                        memberData[0]["CategoryName"] == "" ||
                                memberData[0]["CategoryName"] == null
                            ? ''
                            : '${memberData[0]["CategoryName"]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      memberData[0]["IsPrivate"] != true
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
                                                memberData[0]["Mobile"]
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
                                        _openWhatsapp(memberData[0]["Mobile"]);
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
                                  top: 10, left: 10, right: 10, bottom: 10)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                memberData[0]["IsPrivate"] != true
                                    ? Row(
                                        children: <Widget>[
                                          SizedBox(
                                            child: TextFormField(
                                              controller: edtEmail,
                                              scrollPadding: EdgeInsets.all(0),
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
                                            padding: EdgeInsets.only(left: 10),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (memberData[0]["Email"]
                                                          .toString() ==
                                                      "" ||
                                                  memberData[0]["Email"]
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "null") {
                                                Fluttertoast.showToast(
                                                    msg: "Email Not Found.",
                                                    textColor:
                                                        cnst.appPrimaryMaterialColor[
                                                            700],
                                                    backgroundColor: Colors.red,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              } else {
                                                var url =
                                                    'mailto:${memberData[0]["Email"].toString()}?subject=&body=';
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
                                            padding: EdgeInsets.only(left: 5),
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
            ),
    );
  }
}
