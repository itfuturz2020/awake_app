import 'dart:io';
import 'dart:math';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConclaveOTP extends StatefulWidget {
  @override
  _ConclaveOTPState createState() => _ConclaveOTPState();
}

class _ConclaveOTPState extends State<ConclaveOTP> {
  TextEditingController edtMobile = new TextEditingController();
  TextEditingController controller = TextEditingController();

  var isLoading = false;
  int otpCode;

  String memberId = "", memberMobile = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendOtp();
  }

  showInternetMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  sendOtp() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var rng = new Random();
        int code = rng.nextInt(9999 - 1000) + 1000;
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        memberId = prefs.getString(Session.MemberId);
        memberMobile = prefs.getString(Session.mobile);

        Future res = Services.SendOtp(memberMobile, code.toString());
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.ERROR_STATUS == false) {
            setState(() {
              otpCode = code;
            });
            Fluttertoast.showToast(
                msg: "Otp Send ${data.MESSAGE}",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call");
          //showMsg("$e");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  VerificationStatusUpdate() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.ConclaveCodeVerification(memberId);
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.ERROR_STATUS == false) {
            await prefs.setString(Session.isVerified, "true");
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/ConclaveProfile', (Route<dynamic> route) => false);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call");
          //showMsg("$e");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/ConclaveLogin', (Route<dynamic> route) => false);
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.9,
                  color: cnst.appPrimaryMaterialColor.withOpacity(0.9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Verify Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Text(
                          "OTP has been sent to you on ${memberMobile}. Please enter it below",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      //side: BorderSide(color: cnst.appcolor)),
                      side: BorderSide(width: 0.50, color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.65,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          PinCodeTextField(
                            autofocus: false,
                            controller: controller,
                            highlight: true,
                            pinBoxHeight: 60,
                            pinBoxWidth: 60,
                            highlightColor: cnst.appPrimaryMaterialColor,
                            defaultBorderColor: Colors.grey,
                            hasTextBorderColor: cnst.appPrimaryMaterialColor,
                            maxLength: 4,
                            pinBoxDecoration: ProvidedPinBoxDecoration
                                .defaultPinBoxDecoration,
                            pinTextStyle: TextStyle(fontSize: 20.0),
                            pinTextAnimatedSwitcherTransition:
                                ProvidedPinBoxTextAnimation.scalingTransition,
                            pinTextAnimatedSwitcherDuration:
                                Duration(milliseconds: 200),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 30),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              color: cnst.appPrimaryMaterialColor,
                              minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                if (otpCode.toString() == controller.text) {
                                  VerificationStatusUpdate();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Enter Valid Code",
                                      backgroundColor: Colors.green,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Text(
                                "VERIFY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  Text(
                                    "Didn't Receive the Verification Code ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //print("tap");
                                      if (!isLoading) {
                                        sendOtp();
                                      }
                                    },
                                    child: Text(
                                      'RESEND CODE',
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: cnst.appPrimaryMaterialColor),
                                    ),
                                  ),
                                ],
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
