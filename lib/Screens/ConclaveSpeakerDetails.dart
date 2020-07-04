import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveSpeakerDetails extends StatefulWidget {
  String speakerId;

  ConclaveSpeakerDetails({this.speakerId});

  @override
  _ConclaveSpeakerDetailsState createState() => _ConclaveSpeakerDetailsState();
}

class _ConclaveSpeakerDetailsState extends State<ConclaveSpeakerDetails> {
  TextEditingController edtFeedback = TextEditingController();

  bool isLoading = true;
  List speakerData = [];
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

  @override
  void initState() {
    _getSpeakerDetails();
  }

  _getSpeakerDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile1 = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getSpeakerDetails(widget.speakerId.toString());
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              speakerData = data;
            });
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

  String setDate(date) {
    var dobAy = date.toString().split("-");
    if (date != "" && date != null) {
      if (dobAy[0].toString().length == 1) {
        dobAy[0] = "0" + dobAy[0].toString();
      }
      if (dobAy[1].toString().length == 1) {
        dobAy[1] = "0" + dobAy[1].toString();
      }
      if (dobAy[2].toString().length == 1) {
        dobAy[2] = "0" + dobAy[1].toString();
      }
    }
    String final_Date = "${dobAy[2].toString()}" +
        "/" +
        "${dobAy[1].toString()}" +
        "/" +
        "${dobAy[0].toString()}";

    return final_Date;
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

  _sendSpeakerReview() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String MemberId = preferences.getString(Session.MemberId);
        Future res = Services.sendSpeakerReview(
            widget.speakerId, edtFeedback.text, ratingIndex, MemberId);
        res.then((data) async {
          if (data.ERROR_STATUS == false) {
            //signUpDone("Attendance Send Successfully");

            showMsg("Review Sent Successfully");
            Fluttertoast.showToast(
                msg: "Your Review for Speaker has been sent!!!",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_LONG);
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
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
    double screen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading
          ? LoadingComponent()
          : SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        //height:MediaQuery.of(context).size.height/4.5,
                        color: cnst.appPrimaryMaterialColor,
                        height: screen > 550.0 ? screen / 4 : screen / 4.3,
                        width: MediaQuery.of(context).size.width,
                        //child: Image.asset(''),
                      ),
                      clipper: displayDateClipper(),
                    ),
                    Positioned(
                      top: 5,
                      left: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: screen > 550.0
                              ? MediaQuery.of(context).size.height / 5.7
                              : MediaQuery.of(context).size.height / 6,
                        ),
                        /*margin: EdgeInsets.only(
                      top: height > 550.0
                          ? MediaQuery.of(context).size.height / 5.7
                          : MediaQuery.of(context).size.height / 6,
                    ),*/
                        //margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 120,
                              width: 120,
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
                                          child: speakerData[0]["Image"] ==
                                                      null ||
                                                  speakerData[0]["Image"] == ""
                                              ? Image.asset(
                                                  "images/icon_profile_new.png",
                                                  height: 120,
                                                  width: 120,
                                                  fit: BoxFit.fill,
                                                )
                                              : FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'images/icon_profile_new.png',
                                                  image:
                                                      'IMG_URL${speakerData[0]["Image"]}',
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.fill,
                                                )),
                                      radius: 50.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /*Container(
                                    //height > 550.0 ? padding: const EdgeInsets.only(top: 120) : padding: const EdgeInsets.only(top: 120),
                                    //padding: const EdgeInsets.only(top: 120),
                                    padding: const EdgeInsets.only(top: 50),
                                    //padding: const EdgeInsets.only(top: 120),
                                    child: Text(
                                      "${speakerData[0]["SpeakerName"]}",
                                      style: TextStyle(
                                          color: cnst.appPrimaryMaterialColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )*/
                            Container(
                              //height > 550.0 ? padding: const EdgeInsets.only(top: 120) : padding: const EdgeInsets.only(top: 120),
                              //padding: const EdgeInsets.only(top: 120),
                              padding: const EdgeInsets.only(top: 20),
                              //padding: const EdgeInsets.only(top: 120),
                              child: Text(
                                "${speakerData[0]["SpeakerName"]}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 15, left: 20, right: 20),
                              child: Text(
                                "${speakerData[0]["CompanyName"]}: ${speakerData[0]["Designation"]}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 15, 25, 15),
                              child: Text(
                                "${speakerData[0]["ShortDescription"]}",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25, 15, 25, 15),
                              child: Text(
                                "${speakerData[0]["LongDescription"]}",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: TextFormField(
                                        controller: edtFeedback,
                                        scrollPadding: EdgeInsets.all(0),
                                        decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Colors.black),
                                            ),
                                            hintText: "Feedback"),
                                        keyboardType: TextInputType.text,
                                        maxLines: 3,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: RatingBar(
                                        initialRating: 3,
                                        itemCount: 5,
                                        tapOnlyMode: true,
                                        itemBuilder: (context, index) {
                                          switch (index) {
                                            case 0:
                                              return Icon(
                                                Icons
                                                    .sentiment_very_dissatisfied,
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
                                          print(
                                              "text: ${ratingText[ratingIndex]}");
                                          print(
                                              "color: ${ratingColor[ratingIndex].toString()}");
                                        },
                                      ),
                                    ),
                                    Text(
                                      "${ratingText[ratingIndex]}",
                                      style: TextStyle(
                                          color: ratingColor[ratingIndex]),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      margin: EdgeInsets.only(top: 10),
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        color: cnst.appPrimaryMaterialColor,
                                        minWidth:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        onPressed: () {
                                          _sendSpeakerReview();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Submit Review",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}

class displayDateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(0.0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
