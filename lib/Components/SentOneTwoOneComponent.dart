import 'dart:io';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SentOneTwoOneComponent extends StatefulWidget {
  var sendOneTwoOneData;

  SentOneTwoOneComponent({this.sendOneTwoOneData});

  @override
  _SentOneTwoOneComponentState createState() => _SentOneTwoOneComponentState();
}

class _SentOneTwoOneComponentState extends State<SentOneTwoOneComponent> {
  bool isLoading = false;

  _updateOneTwoOneStatus(String status) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.updateOneTwoOneStatus(
            widget.sendOneTwoOneData["Id"].toString(), status, "sender");
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          setState(() {
            isLoading = false;
          });

          if (data.ERROR_STATUS == false) {
            setState(() {
              if (widget.sendOneTwoOneData["Status"] == "Accepted") {
                widget.sendOneTwoOneData["Status"] = "Completed";
              }
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

  setDateTime(dateTime) {
    var datetime = dateTime.split(" ");
    var date = datetime[0].toString().split("/");
    var formattedDateTime = date[1];
    var month = "";
    switch (date[0]) {
      case "1":
        month = "January";
        break;
      case "2":
        month = "February";
        break;
      case "3":
        month = "March";
        break;
      case "4":
        month = "April";
        break;
      case "5":
        month = "May";
        break;
      case "6":
        month = "June";
        break;
      case "7":
        month = "July";
        break;
      case "8":
        month = "August";
        break;
      case "9":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }
    formattedDateTime = formattedDateTime + " " + month + ", " + date[2] + " ";
    var time = datetime[1].toString().split(":");
    formattedDateTime =
        formattedDateTime + time[0] + ":" + time[1] + " " + datetime[2];
    return formattedDateTime;
  }

  confirmDialog(String msg, String status) {
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
                Navigator.of(context).pop();
                if (status == " not") {
                  launch("tel:${widget.sendOneTwoOneData["MobileNo"]}");
                } else if (status == "Completed") {
                  _updateOneTwoOneStatus("Completed");
                  //updateStatus("Completed");
                }
              },
            ),
          ],
        );
      },
    );
  }

  /* updateStatus(String s) {
    setState(() {
      status = s;
    });
  }*/

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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.sendOneTwoOneData["Image"] == null ||
                        widget.sendOneTwoOneData["Image"] == ""
                    ? ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'images/no_image.png',
                          image: "",
                          height: 60,
                          width: 60,
                          fit: BoxFit.fill,
                        ),
                      )
                    : ClipOval(
                        child: FadeInImage.assetNetwork(
                          //placeholder: 'images/no_image.png',
                          //placeholder: 'images/icon_user.png',
                          placeholder: 'assets/loading.gif',
                          image: IMG_URL + widget.sendOneTwoOneData["Image"],
                          height: 60,
                          width: 60,
                          fit: BoxFit.fill,
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${widget.sendOneTwoOneData["Name"]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Text("${widget.sendOneTwoOneData["CategoryName"]}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 13)),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 0, bottom: 5),
            child: Row(
              children: <Widget>[
                Text(
                  widget.sendOneTwoOneData["MeetingType"] == null ||
                          widget.sendOneTwoOneData["MeetingType"] == ""
                      ? "Physical"
                      : "${widget.sendOneTwoOneData["MeetingType"]}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                widget.sendOneTwoOneData["MeetingType"] == "Zoom"
                    ? GestureDetector(
                        onTap: () {
                          launch("${widget.sendOneTwoOneData["ZoomLink"]}");
                        },
                        child: Text(
                          "   Open Zoom",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${setDateTime(widget.sendOneTwoOneData["Date_Time"].toString())}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                              shape: BoxShape.circle,
                              color: widget.sendOneTwoOneData["Status"] ==
                                      "Requested"
                                  ? Colors.white
                                  : Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.asset(
                              "images/send.png",
                              height: 15,
                              width: 15,
                              fit: BoxFit.fill,
                              color: widget.sendOneTwoOneData["Status"] ==
                                      "Requested"
                                  ? Colors.green
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          color:
                              widget.sendOneTwoOneData["Status"] == "Requested"
                                  ? Colors.grey
                                  : Colors.green,
                          height: 2.0,
                          width: 30.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.sendOneTwoOneData["Status"] !=
                                "Requested") {
                              confirmDialog(
                                  "Are you sure about Call on ${widget.sendOneTwoOneData["MobileNo"]} ?",
                                  "call");
                            } else {
                              showHHMsg(
                                  "You can't call this Member. You have to wait till accept your 1-2-1 request.");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.sendOneTwoOneData["Status"] !=
                                            "Requested"
                                        ? Colors.green
                                        : Colors.grey,
                                    width: 2),
                                shape: BoxShape.circle,
                                color: widget.sendOneTwoOneData["Status"] !=
                                        "Requested"
                                    ? Colors.green
                                    : Colors.white),
                            child: Padding(
                                padding: const EdgeInsets.all(3.5),
                                child: Icon(Icons.phone,
                                    color: widget.sendOneTwoOneData["Status"] !=
                                            "Requested"
                                        ? Colors.white
                                        : Colors.grey,
                                    size: 20)),
                          ),
                        ),
                        Container(
                          color:
                              widget.sendOneTwoOneData["Status"] == "Completed"
                                  ? Colors.green
                                  : Colors.grey,
                          height: 2.0,
                          width: 30.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.sendOneTwoOneData["Status"] ==
                                "Completed") {
                              showHHMsg(
                                  "Your 1-2-1 Meeting is already Completed.");
                            } else if (widget.sendOneTwoOneData["Status"] ==
                                "Accepted") {
                              confirmDialog(
                                  "Are you shared your Referal?", "Completed");
                            } else {
                              showHHMsg(
                                  "You can't request for Complete 1-2-1 Meeting.");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.sendOneTwoOneData["Status"] ==
                                            "Completed"
                                        ? Colors.green
                                        : Colors.grey,
                                    width: 2),
                                shape: BoxShape.circle,
                                color: widget.sendOneTwoOneData["Status"] ==
                                        "Completed"
                                    ? Colors.green
                                    : Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                "images/ribbon.png",
                                height: 15,
                                width: 15,
                                fit: BoxFit.fill,
                                color: widget.sendOneTwoOneData["Status"] ==
                                        "Completed"
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appPrimaryMaterialColor,
                          onPressed: () {},
                          child: Text(
                            "1-2-1 with ED",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )*/
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
