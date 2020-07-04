import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Screens/AddTContact.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ConclaveCategoryMemberView extends StatefulWidget {
  var memberData;

  ConclaveCategoryMemberView({this.memberData});

  @override
  _ConclaveCategoryMemberViewState createState() =>
      _ConclaveCategoryMemberViewState();
}

class _ConclaveCategoryMemberViewState
    extends State<ConclaveCategoryMemberView> {
  String status = "";
  bool isLoading = true, OneTwoOneRequest = false;
  String OneTwoOneType = "Physical";
  TextEditingController edtZoomLink = new TextEditingController();
  _addOneTwoOneStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String senderId = preferences.getString(Session.MemberId);
        Future res = Services.AddOneTwoOneRequest(
            senderId,
            widget.memberData["Id"].toString(),
            OneTwoOneType,
            edtZoomLink.text);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          setState(() {
            isLoading = false;
          });

          if (data.ERROR_STATUS == false) {
            setState(() {
              widget.memberData["Status"] = "Requested";
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Category Data Call $e");
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

  _openWhatsApp(String mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  showHHMsg(String msg) {
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
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
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

  confirmDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation !!!"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.pop(context);
                //AskOneTwoOneType("Pick one option for 1-2-1 Meeting");
                _addOneTwoOneStatus();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Member Details"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                height: widget.memberData["IsPrivate"] != true
                    ? MediaQuery.of(context).size.height - 193
                    : MediaQuery.of(context).size.height - 150,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      widget.memberData["AdvertisementImage"] != null &&
                              widget.memberData["AdvertisementImage"] != ""
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/loading.gif',
                                image:
                                    'IMG_URL${widget.memberData["AdvertisementImage"]}',
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                  ),
                                ]),
                            child: GestureDetector(
                              onTap: () {},
                              child: AvatarGlow(
                                //startDelay: Duration(milliseconds: 1500),
                                glowColor: cnst.appPrimaryMaterialColor,
                                endRadius: 80.0,
                                duration: Duration(milliseconds: 2000),
                                repeat: true,
                                showTwoGlows: true,
                                repeatPauseDuration:
                                    Duration(milliseconds: 100),
                                child: Material(
                                  elevation: 8.0,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    child: ClipOval(
                                        child: widget.memberData["Image"] ==
                                                    null ||
                                                widget.memberData["Image"] == ""
                                            ? Image.asset(
                                                "images/awec.png",
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.fill,
                                              )
                                            : FadeInImage.assetNetwork(
                                                placeholder:
                                                    'images/icon_profile_new.png',
                                                image:
                                                    'IMG_URL${widget.memberData["Image"]}',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,
                                              )),
                                    radius: 40.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  //height > 550.0 ? padding: const EdgeInsets.only(top: 120) : padding: const EdgeInsets.only(top: 120),
                                  //padding: const EdgeInsets.only(top: 120),
                                  padding: const EdgeInsets.only(top: 20),
                                  //padding: const EdgeInsets.only(top: 120),
                                  child: Text(
                                    "${widget.memberData["Name"]}",
                                    style: TextStyle(
                                        color: cnst.appPrimaryMaterialColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "Company: ${widget.memberData["Company"]}",
                                    style: TextStyle(
                                        color: cnst.appPrimaryMaterialColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          children: <Widget>[
                            widget.memberData["IsPrivate"] != true
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.email,
                                              color:
                                                  cnst.appPrimaryMaterialColor,
                                            ),
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5.2,
                                              child: Text(
                                                "E-mail",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: cnst
                                                        .appPrimaryMaterialColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ))
                                        ],
                                      ),
                                      Expanded(
                                          child: Text(
                                        "${widget.memberData["Email"]}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ))
                                    ],
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.location_on,
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5.2,
                                          child: Text(
                                            "Address",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ],
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${widget.memberData["City"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.business_center,
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5.2,
                                          child: Text(
                                            "Category",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ],
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${widget.memberData["CategoryName"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Column(
              children: <Widget>[
                /*Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: widget.memberData["Status"] == "Requested" ||
                                    widget.memberData["Status"] == "Completed"
                                ? Colors.white
                                : cnst.appPrimaryMaterialColor,
                            width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: widget.memberData["Status"] == "Requested"
                          ? cnst.appPrimaryMaterialColor
                          : widget.memberData["Status"] == "Completed"
                              ? Colors.green
                              : Colors.white,
                      onPressed: () {
                        if (widget.memberData["Status"] == "") {
                          confirmDialog("Are you sure to Send 1-2-1 Request?");
                        } else if (widget.memberData["Status"] == "Requested") {
                          showHHMsg("Your 1-2-1 Request is already sent !!!");
                        } else if (widget.memberData["Status"] == "Completed") {
                          showHHMsg(
                              "Your 1-2-1 Meeting is already Completed.\nYou can't send another Request for 1-2-1 !!!");
                        }
                      },
                      child: Text(
                        widget.memberData["Status"] == "Requested"
                            ? "1-2-1 Requested"
                            : widget.memberData["Status"] == "Completed"
                                ? "1-2-1 Completed"
                                : "Send 1-2-1",
                        style: TextStyle(
                            color: widget.memberData["Status"] == "Requested" ||
                                    widget.memberData["Status"] == "Completed"
                                ? Colors.white
                                : cnst.appPrimaryMaterialColor,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                OneTwoOneRequest
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                                value: "Physical",
                                onChanged: (String value) {
                                  setState(() {
                                    OneTwoOneType = "Physical";
                                  });
                                },
                                groupValue: OneTwoOneType,
                              ),
                              Text("Physical")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                value: "Zoom",
                                onChanged: (String value) {
                                  setState(() {
                                    OneTwoOneType = "Zoom";
                                  });
                                },
                                groupValue: OneTwoOneType,
                              ),
                              Text("Zoom")
                            ],
                          ),
                        ],
                      )
                    : Container(),
                OneTwoOneType == "Zoom"
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 75,
                        child: TextFormField(
                          controller: edtZoomLink,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              counterText: "",
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: "Zoom Link",
                              hintText: "Zoom Link"),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : Container(),
                OneTwoOneRequest
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: cnst.appPrimaryMaterialColor,
                            onPressed: () {
                              _addOneTwoOneStatus();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 11, right: 11),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),*/
                widget.memberData["IsPrivate"] != true
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 0, bottom: 0),
                        height: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (widget.memberData["Email"].toString() ==
                                        "" ||
                                    widget.memberData["Email"]
                                            .toString()
                                            .toLowerCase() ==
                                        "null") {
                                  Fluttertoast.showToast(
                                      msg: "Email Not Found.",
                                      textColor:
                                          cnst.appPrimaryMaterialColor[700],
                                      backgroundColor: Colors.red,
                                      gravity: ToastGravity.CENTER,
                                      toastLength: Toast.LENGTH_SHORT);
                                } else {
                                  var url =
                                      'mailto:${widget.memberData["Email"].toString()}?subject=&body=';
                                  launch(url);
                                }
                              },
                              child: Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width / 4,
                                color: Colors.pink[50],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Image.asset(
                                    'images/mail.png',
                                    height: 22,
                                    width: 32,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launch("tel:" +
                                    widget.memberData["Mobile"].toString());
                              },
                              child: Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width / 4,
                                color: Colors.black26,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Image.asset(
                                    'images/icon_circle_phone.png',
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _openWhatsApp(widget.memberData["Mobile"]);
                              },
                              child: Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width / 4,
                                color: Colors.green[100],
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Image.asset(
                                    'images/icon_Whatsapp.png',
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddTContact(
                                              memberData: widget.memberData,
                                            )));
                              },
                              child: Container(
                                height: 42,
                                width: MediaQuery.of(context).size.width / 4,
                                color: Colors.black12,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7),
                                  child: Icon(
                                    Icons.person_add,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
