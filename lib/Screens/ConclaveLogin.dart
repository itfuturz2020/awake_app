import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveLogin extends StatefulWidget {
  @override
  _ConclaveLoginState createState() => _ConclaveLoginState();
}

class _ConclaveLoginState extends State<ConclaveLogin> {
  TextEditingController edtMobile = new TextEditingController();
  bool isLoading = false;
  ProgressDialog pr;

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
    //pr.setMessage('Please Wait');
    // TODO: implement initState
    super.initState();
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

  checkLogin() async {
    if (edtMobile.text != "" && edtMobile.text != null) {
      if (edtMobile.text.length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            /*setState(() {
              isLoading = true;
            });*/
            pr.show();
            Future res = Services.ConclaveLogin(edtMobile.text);
            res.then((data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (data != null && data.length > 0) {
                pr.hide();
                await prefs.setString(
                    Session.MemberId, data[0]["Id"].toString());
                await prefs.setString(Session.name, data[0]["Name"].toString());
                await prefs.setString(
                    Session.mobile, data[0]["Mobile"].toString());
                await prefs.setString(
                    Session.email, data[0]["Email"].toString());
                await prefs.setString(
                    Session.company, data[0]["Company"].toString());
                await prefs.setString(
                    Session.category, data[0]["Category"].toString());
                await prefs.setString(Session.city, data[0]["City"].toString());
                await prefs.setString(
                    Session.categoryName, data[0]["CategoryName"].toString());
                await prefs.setString(Session.type, data[0]["Type"].toString());
                await prefs.setString(
                    Session.isVerified, data[0]["IsVerified"].toString());
                await prefs.setString(
                    Session.isPrivate, data[0]["IsPrivate"].toString());
                await prefs.setString(
                    Session.GSTNumber, data[0]["GSTNumber"].toString());
                await prefs.setString(
                    Session.TransactionId, data[0]["TransactionId"].toString());
                await prefs.setString(
                    Session.ChapterName, data[0]["ChapterName"].toString());
                await prefs.setString(
                    Session.RegAmt, data[0]["RegAmt"].toString());
                print("id: ${prefs.getString(Session.MemberId)}");
                if (data[0]["IsVerified"].toString() == "false") {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/ConclaveOTP', (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/ConclaveProfile', (Route<dynamic> route) => false);
                }
                //Navigator.pushReplacementNamed(context, '/ConclaveDashboard');
              } else {
                pr.hide();
                showMsg("Invalid login Detail.");
              }
            }, onError: (e) {
              pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            pr.hide();
            showMsg("Something wen wrong");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        showMsg("Please Enter Valid Mobile No.");
      }
    } else {
      showMsg("Please Enter Mobile No.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 50),
                    child: Image.asset(
                      "images/awec.png",
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 230.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    height: 75,
                    child: TextFormField(
                      controller: edtMobile,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          counterText: "",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: cnst.appPrimaryMaterialColor,
                          ),
                          labelText: "Mobile No",
                          hintText: "Mobile No"),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: cnst.appPrimaryMaterialColor,
                      minWidth: MediaQuery.of(context).size.width - 20,
                      onPressed: () {
                        checkLogin();
                        //Navigator.pushReplacementNamed(context, '/ConclaveDashboard');
                      },
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/ConclaveSignUp');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account ? ",
                              style: TextStyle(fontSize: 14)),
                          Text("REGISTER",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: cnst.appPrimaryMaterialColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
