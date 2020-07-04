import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackScreen> {
  int ratingIndex = 2;
  String rating = "Good";
  List<String> ratingText = ["Poor", "Bad", "Good", "Very Good", "Excellent"];
  List<Color> ratingColor = [
    Colors.red,
    Colors.redAccent,
    Colors.amber[800],
    Colors.lightGreen,
    Colors.green
  ];

  String memberId = "";

  //loading var
  bool isLoading = false;

  List list = new List();
  TextEditingController edtDesc = new TextEditingController();

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
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
    super.initState();
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      memberId = prefs.getString(Session.MemberId);
    });
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("BNI Evolve"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  signUpDone(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
                //Navigator.pushReplacementNamed(context, '/Login');
              },
            ),
          ],
        );
      },
    );
  }

  sendFeedback() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String MemberId = preferences.getString(Session.MemberId);
        Future res = Services.ConclaveFeedback(ratingIndex.toString(),
            edtDesc.text.replaceAll(" ", "%20"), MemberId);
        res.then((data) async {
          pr.hide();
          if (data.Data == "1") {
            showMsg("Feedback Sent Successfully");
            setState(() {
              edtDesc.text = "";
            });
          } else {
            pr.hide();
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          print("Error : on Login Call $e");
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cnst.appPrimaryMaterialColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          'Feedback',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.3,
              color: cnst.appPrimaryMaterialColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        'Send us Your Feedback !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 25, right: 25),
                      child: Text(
                        "Do you Have Any Suggestion or Found Some Bug?\nlet us know in the Below",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 25),
              padding: EdgeInsets.only(left: 10),
              color: cnst.appPrimaryMaterialColor,
              height: 50,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/Dashboard');
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 25,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),*/
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  //side: BorderSide(color: cnst.appcolor)),
                  side: BorderSide(width: 0.50, color: Colors.grey[500]),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4.4,
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  //color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'How was your experience ?',
                            style: TextStyle(
                                fontSize: 16,
                                color: cnst.appPrimaryMaterialColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '(Select a star amount )',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RatingBar(
                              initialRating: 3,
                              itemCount: 5,
                              tapOnlyMode: true,
                              itemBuilder: (context, index) {
                                switch (index) {
                                  case 0:
                                    return Icon(
                                      Icons.sentiment_very_dissatisfied,
                                      color: ratingColor[index],
                                    );
                                    break;
                                  case 1:
                                    return Icon(
                                      Icons.sentiment_dissatisfied,
                                      color: ratingColor[index],
                                    );
                                    break;
                                  case 2:
                                    return Icon(
                                      Icons.sentiment_neutral,
                                      color: ratingColor[index],
                                    );
                                    break;
                                  case 3:
                                    return Icon(
                                      Icons.sentiment_satisfied,
                                      color: ratingColor[index],
                                    );
                                    break;
                                  case 4:
                                    return Icon(
                                      Icons.sentiment_very_satisfied,
                                      color: ratingColor[index],
                                    );
                                    break;
                                }
                              },
                              onRatingUpdate: (rating) {
                                setState(() {
                                  ratingIndex = rating.toInt() - 1;
                                  print("Ratiing : ${ratingIndex}");
                                });
                                print("index: ${ratingIndex}");
                                print("text: ${ratingText[ratingIndex]}");
                                print(
                                    "color: ${ratingColor[ratingIndex].toString()}");
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          "${ratingText[ratingIndex]}",
                          style: TextStyle(color: ratingColor[ratingIndex]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: edtDesc,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              hintText: "Describe Your Experience here..",
                              hintStyle: TextStyle(fontSize: 13)),
                          maxLines: 4,
                          minLines: 2,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                          top: 25,
                        ),
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 20,
                          onPressed: () {
                            if (isLoading == false) {
                              sendFeedback();
                            }
                          },
                          child: Text(
                            "Submit Feedback",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: isLoading ? LoadingComponent() : Container(),
            )
          ],
        )),
      ),
    );
  }
}
