import 'dart:io';

import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ConclaveSignUp extends StatefulWidget {
  @override
  _ConclaveSignUpState createState() => _ConclaveSignUpState();
}

class _ConclaveSignUpState extends State<ConclaveSignUp> {
  String selectType = "BNI Lucknow Member";

  int price = 1500;

  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobileNo = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtCmpName = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtGSTNo = new TextEditingController();

  //TextEditingController edtCategory = new TextEditingController();
  TextEditingController edtChapterName = new TextEditingController();
  ProgressDialog pr;
  List<categoryClass> _categoryList = [];
  categoryClass selectCategory;
  List<ChapterClass> _chapterList = [];
  ChapterClass selectChapter;
  String selectedChapterId;
  bool isLoading = true;

  void initState() {
    _getCategory();
    _getChapter();
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

  _getCategory() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetCategory();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _categoryList = data;
              isLoading = false;
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

  _getChapter() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetLucknowChapter();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _chapterList = data;
              isLoading = false;
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

  singnUp() async {
    if (edtName.text != null &&
        edtMobileNo.text != null &&
        edtMobileNo.text.length == 10 &&
        edtEmail.text != null &&
        edtCmpName.text != null &&
        edtCity.text != null &&
        selectCategory != null) {
      try {
        bool flag = false;
        if (selectType == "BNI Lucknow Member") {
          if (selectChapter == null) {
            setState(() {
              flag = true;
            });
          }
        }
        if (selectType == "BNI Other Region Member") {
          if (edtChapterName.text == null) {
            setState(() {
              flag = true;
            });
          }
        }
        if (flag == true) {
          showMsg("Please Fill All Data.");
        } else {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print(
                "Data: ${edtName.text},${edtMobileNo.text},${edtEmail.text},${selectType},${selectChapter},${edtChapterName.text},${edtCity.text},${selectCategory.CategoryName},${edtGSTNo.text}");
            String chapter = "";
            if (selectType == "BNI Lucknow Member") {
              chapter = selectChapter.name;
            } else if (selectType == "BNI Other Region Member") {
              chapter = edtChapterName.text;
            } else {
              chapter = "";
            }
            print(
                "${edtName.text}${edtMobileNo.text}${edtEmail.text}${selectType}${chapter}${edtCmpName.text}${edtCity.text}${selectCategory.Id}${edtGSTNo.text}${price.toString()}");
            Future res = Services.conclaveSignUp(
                edtName.text,
                edtMobileNo.text,
                edtEmail.text,
                selectType,
                chapter,
                edtCmpName.text,
                edtCity.text,
                selectCategory.Id,
                edtGSTNo.text,
                price.toString());
            res.then((data) async {
              if (data.ERROR_STATUS == false && data.RECORDS == true) {
                pr.hide();
                signUpDone("Registration Done Successfully");
              } else {
                pr.hide();
                showMsg("${data.MESSAGE}");
              }
            }, onError: (e) {
              pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            pr.hide();
            showMsg("No Internet Connection.");
          }
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      showMsg("Please Fill All Data.");
    }
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
              child: new Text(
                "Okay",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                edtName.clear();
                edtMobileNo.clear();
                edtEmail.clear();
                edtCmpName.clear();
                edtCity.clear();
                edtChapterName.clear();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/ConclaveLogin');
              },
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/ConclaveLogin');
        },
        child: isLoading
            ? LoadingComponent()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 25, right: 25),
                child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Image.asset("images/awec.png",
                                width: 190.0, height: 130.0, fit: BoxFit.fill),
                          ),
                          Container(
                            child: TextFormField(
                              controller: edtName,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  labelText: "Name",
                                  hintText: "Name"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtMobileNo,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtEmail,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  labelText: "E-Mail",
                                  hintText: "demo@demo.com"),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.only(left: 20),
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                isExpanded: true,
                                hint: Text('Member Type'),
                                value: selectType,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectType = newValue;
                                    selectChapter = null;
                                    if (selectType == "Non-BNI Member") {
                                      price = 110;
                                    } else {
                                      price = 1500;
                                    }
                                  });
                                  print("Price: ${price}");
                                },
                                items: <String>[
                                  'BNI Lucknow Member',
                                  'BNI Other Region Member',
                                  'Non-BNI Member'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style:
                                            TextStyle(color: Colors.black54)),
                                  );
                                }).toList(),
                              ))),
                          selectType == "BNI Lucknow Member"
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 20),
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 1),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text('Select Chapter'),
                                    value: selectChapter,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectChapter = newValue;
                                        selectedChapterId = newValue.chapterid;
                                      });
                                    },
                                    items: _chapterList
                                        .map((ChapterClass _chapter) {
                                      return new DropdownMenuItem<ChapterClass>(
                                        value: _chapter,
                                        child: Text(
                                          _chapter.name,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                  )))
                              : selectType == "BNI Other Region Member"
                                  ? Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        controller: edtChapterName,
                                        scrollPadding: EdgeInsets.all(0),
                                        decoration: InputDecoration(
                                            border: new OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            prefixIcon: Icon(
                                              Icons.category,
                                              color:
                                                  cnst.appPrimaryMaterialColor,
                                            ),
                                            hintText: "Chapter Name"),
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  : Container(),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtCmpName,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.business,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  hintText: "Company Name"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtCity,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.location_city,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  hintText: "City"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.only(left: 20),
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                isExpanded: true,
                                hint: Text('Select Category'),
                                value: selectCategory,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectCategory = newValue;
                                  });
                                },
                                items: _categoryList
                                    .map((categoryClass _category) {
                                  return new DropdownMenuItem<categoryClass>(
                                    value: _category,
                                    child: Text(
                                      _category.CategoryName,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ))),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: edtGSTNo,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: cnst.appPrimaryMaterialColor,
                                  ),
                                  hintText: "GST No"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              color: cnst.appPrimaryMaterialColor,
                              minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                singnUp();
                              },
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
