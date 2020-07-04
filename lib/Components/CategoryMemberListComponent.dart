import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Screens/ConclaveCategoryMemberView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryMemberListComponent extends StatefulWidget {
  var categoryMemberData;

  CategoryMemberListComponent({this.categoryMemberData});

  @override
  _CategoryMemberListComponentState createState() =>
      _CategoryMemberListComponentState();
}

class _CategoryMemberListComponentState
    extends State<CategoryMemberListComponent> {
  TextEditingController edtZoomLink = new TextEditingController();
  bool isLoading = false, OneTwoOneRequest = false;
  String OneTwoOneType = "Physical";
  _addOneTwoOneStatus() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String senderId = preferences.getString(Session.MemberId);
        Future res = Services.AddOneTwoOneRequest(
            senderId,
            widget.categoryMemberData["Id"].toString(),
            OneTwoOneType,
            edtZoomLink.text);

        res.then((data) async {
          setState(() {
            isLoading = false;
            OneTwoOneRequest = false;
          });

          if (data.ERROR_STATUS == false) {
            setState(() {
              widget.categoryMemberData["Status"] = "Requested";
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

  _openWhatsApp(mobile) {
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
                setState(() {
                  OneTwoOneRequest = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.only(top: 5, right: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.categoryMemberData["Image"] != "" &&
                        widget.categoryMemberData["Image"] != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: IMG_URL + widget.categoryMemberData["Image"],
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(7),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: cnst.appPrimaryMaterialColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75))),
                          width: 50,
                          height: 50,
                          child: Center(
                              child: Text(
                                  "${widget.categoryMemberData["Name"].toString().substring(0, 1)}",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 19,
                                      color: Colors.white))),
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${widget.categoryMemberData["Name"]}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        Text("${widget.categoryMemberData["Company"]}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700])),
                        Text("${widget.categoryMemberData["CategoryName"]}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          width: MediaQuery.of(context).size.width / 2.6,
                          height: 37,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: widget.categoryMemberData["Status"] ==
                                              "Requested" ||
                                          widget.categoryMemberData["Status"] ==
                                              "Completed"
                                      ? Colors.white
                                      : cnst.appPrimaryMaterialColor,
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: widget.categoryMemberData["Status"] ==
                                    "Requested"
                                ? cnst.appPrimaryMaterialColor
                                : widget.categoryMemberData["Status"] ==
                                        "Completed"
                                    ? Colors.green
                                    : Colors.white,
                            onPressed: () {
                              if (widget.categoryMemberData["Status"] == "" ||
                                  widget.categoryMemberData["Status"] == null) {
                                confirmDialog(
                                    "Are you sure to Send 1-2-1 Request?");
                              } else if (widget.categoryMemberData["Status"] ==
                                  "Requested") {
                                showHHMsg(
                                    "Your 1-2-1 Request is already sent !!!");
                              } else if (widget.categoryMemberData["Status"] ==
                                  "Completed") {
                                showHHMsg(
                                    "Your 1-2-1 Meeting is already Completed.\nYou can't send another Request for 1-2-1 !!!");
                              } else {
                                showHHMsg(
                                    "Your 1-2-1 Request is accepeted !!!");
                              }
                            },
                            child: Text(
                              widget.categoryMemberData["Status"] == "Requested"
                                  ? "1-2-1 Requested"
                                  : widget.categoryMemberData["Status"] ==
                                          "Accepted"
                                      ? "1-2-1 Accepted"
                                      : widget.categoryMemberData["Status"] ==
                                              "Completed"
                                          ? "1-2-1 Completed"
                                          : "Send 1-2-1",
                              style: TextStyle(
                                  color: widget.categoryMemberData["Status"] ==
                                              "Requested" ||
                                          widget.categoryMemberData["Status"] ==
                                              "Completed"
                                      ? Colors.white
                                      : cnst.appPrimaryMaterialColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.6,
                    height: 37,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: cnst.appPrimaryMaterialColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ConclaveCategoryMemberView(
                                      memberData: widget.categoryMemberData,
                                    )));
                      },
                      child: Text(
                        "View Profile",
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            OneTwoOneRequest
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 15),
                    child: Text("Select 1-2-1 Meeting Type",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                : Container(),
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
            OneTwoOneType == "Zoom" && OneTwoOneRequest
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 75,
                    child: TextFormField(
                      controller: edtZoomLink,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          counterText: "",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
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
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        color: cnst.appPrimaryMaterialColor,
                        onPressed: () {
                          _addOneTwoOneStatus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 11, right: 11),
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
                : Container()
          ],
        ),
      ),
    );
  }
}

/*class AskType extends StatefulWidget {
  String msg;
  AskType(this.msg);
  @override
  _AskTypeState createState() => _AskTypeState();
}

class _AskTypeState extends State<AskType> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(widget.msg),
      content: Column(
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
      ),
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
            print("sd: ${OneTwoOneType}");
            Navigator.pop(context);
            //_addOneTwoOneStatus();
          },
        ),
      ],
    );
  }
}*/
