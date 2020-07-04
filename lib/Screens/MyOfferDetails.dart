import 'dart:io';

import 'package:awake_app/Common/Services.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';

class MyOfferDetails extends StatefulWidget {
  String offerId;

  MyOfferDetails({this.offerId});
  @override
  _MyOfferDetailsState createState() => _MyOfferDetailsState();
}

class _MyOfferDetailsState extends State<MyOfferDetails> {
  bool isLoading = true;
  List offerData = new List();

  String day = "", month = "", year = "";

  @override
  void initState() {
    _getOfferDetails();
    //print(widget.offerId);
  }

  _getOfferDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getOfferDetails("${widget.offerId}");
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              offerData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Data Not Found",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Myask Call $e");
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

  String setExpiryDate() {
    var dobAy;
    if (offerData[0]["ExpiryDate"] != "" ||
        offerData[0]["ExpiryDate"] != null) {
      dobAy = offerData[0]["ExpiryDate"].toString().split("/");
    }

    setState(() {
      day = dobAy[1].toString();
      month = dobAy[0].toString();
      year = dobAy[2].toString().substring(0, 4);
    });

    return "${day}-${month}-${year}";
  }

  @override
  Widget build(BuildContext context) {print("d: ${offerData[0]["Title"]}");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Offers"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 5),

                child: Column(
                  children: <Widget>[
                    offerData[0]["Image"] == null || offerData[0]["Image"] == ""
                        ? Image.asset(
                            "images/awec.png",
                            width: MediaQuery.of(context).size.width,
                            height: 180.0,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "images/awec.png",
                            // offerData[0]["Image"],
                            width: MediaQuery.of(context).size.width,
                            height: 180.0,
                            fit: BoxFit.cover,
                          ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: cnst.appPrimaryMaterialColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Center(
                          child: Text(
                            //"Offer Title",
                            offerData[0]["Title"],
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        offerData[0]["Description"],
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Expired on : ${setExpiryDate()}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
