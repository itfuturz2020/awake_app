import 'dart:convert';
import 'dart:io';

import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveProfile extends StatefulWidget {
  @override
  _ConclaveProfileState createState() => _ConclaveProfileState();
}

class _ConclaveProfileState extends State<ConclaveProfile> {
  //Personal Info
  String selectType,
      selectTypeValue = "Select Member Type",
      MemberId = "",
      MemberName = "",
      MemberImage = "",
      Company = "",
      Category = "",
      Mobile = "",
      Email = "",
      City = "",
      Type = "",
      IsPrivate = "",
      selectCategoryName = "",
      selectCategoryId = "",
      AdvertisementImage = "";
  int amount;
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobileNo = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtCmpName = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtBusinessCategory = new TextEditingController();
  TextEditingController edtGSTNo = new TextEditingController();
  List UserData = [];

  //TextEditingController edtCategory = new TextEditingController();
  TextEditingController edtChapterName = new TextEditingController();
  ProgressDialog pr;
  List<categoryClass> _categoryList = [];
  categoryClass selectCategory;
  bool isLoading = true;
  String memberId = '', name = '', mobile = '', company = '';
  String category = '';
  String email = '';
  String city = '';
  String type = '';
  String qrData = '';
  File _imageUserPhoto, _imageAdvertisementPhoto;
  String hasStall;
  String _isPrivate;
  List<ChapterClass> _chapterList = [];
  ChapterClass selectChapter;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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

    _getStallDataCheckByMobile();
  }

  _getStallDataCheckByMobile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetStallDataCheckByMobile(memberMobile);
        res.then((data) async {
          if (data.ERROR_STATUS == false) {
            setState(() {
              isLoading = false;
              hasStall = data.Data.toString();
              print("Has Stall : ${data}");
              if (hasStall == "true") {
                Type = "stall";
              } else {
                Type = "visitor";
              }
              _getLocalData();

              print("Type: ${Type}");
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

  _getLocalData() async {
    await _getChapter();
    await _getCategory();
    _getUserData();
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

            SharedPreferences prefs = await SharedPreferences.getInstance();
            String category = prefs.getString(cnst.Session.category);
            if (category != "" && category != null) {
              for (int i = 0; i < _categoryList.length; i++) {
                if (_categoryList[i].Id == category) {
                  setState(() {
                    selectCategory = _categoryList[i];
                  });
                }
              }
            } else {
              setState(() {
                selectCategoryName = "Select Category";
                selectCategoryId = "";
              });
            }
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

  _getUserData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetConclaveMemberData();
        /*setState(() {
          isLoading = true;
        });*/
        res.then((data) async {
          if (data.length > 0) {
            setState(() {
              UserData = data;
              //isLoading = false;
            });
            await setData();
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
          print("Error : on Member Data Call $e");
          showMsg("$e");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gst = prefs.getString(cnst.Session.GSTNumber);

    setState(() {
      MemberId = UserData[0]["Id"].toString();
      MemberName = UserData[0]["Name"].toString();
      MemberImage = UserData[0]["Image"].toString();
      AdvertisementImage = UserData[0]["AdvertisementImage"].toString();
      Mobile = UserData[0]["MobileNo"].toString();
      edtCmpName.text = UserData[0]["Company"].toString();
      edtEmail.text = UserData[0]["Email"].toString();
      edtCity.text = UserData[0]["City"].toString();
      Category = UserData[0]["Category"].toString();
      edtBusinessCategory.text = UserData[0]["BusinessCategory"].toString();
      edtChapterName.text = UserData[0]["ChapterName"].toString();
      gst == null || gst == "" ? Container() : edtGSTNo.text = gst;
      selectType = UserData[0]["Type"];
      _isPrivate = prefs.getString(cnst.Session.isPrivate);
      amount = int.parse(prefs.getString(cnst.Session.RegAmt));
    });

    setState(() {
      qrData = ((MemberId != null ? MemberId : '') +
          ',' +
          (MemberName != null ? MemberName : '') +
          ',' +
          (_isPrivate != "true" ? Mobile != null ? Mobile : '' : '') +
          ',' +
          (UserData[0]["Company"].toString() != null
              ? UserData[0]["Company"].toString()
              : '') +
          ',' +
          (Category != null ? Category : '') +
          ',' +
          (_isPrivate != "true"
              ? UserData[0]["Email"].toString() != null
                  ? UserData[0]["Email"].toString()
                  : ''
              : '') +
          ',' +
          (Type != null ? Type : ''));
    });
    print("QRString : " + qrData);

    if (selectType == "BNI Lucknow Member") {
      for (int i = 0; i < _chapterList.length; i++) {
        //print("${data[i]}");
        if (UserData[0]["ChapterName"] == _chapterList[i].name) {
          setState(() {
            selectChapter = _chapterList[i];
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void _profileImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      Navigator.pop(context);
                      if (image != null) {
                        setState(() {
                          _imageUserPhoto = image;
                        });
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: _imageUserPhoto.path,
                            aspectRatioPresets: Platform.isAndroid
                                ? [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ]
                                : [
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio5x3,
                                    CropAspectRatioPreset.ratio5x4,
                                    CropAspectRatioPreset.ratio7x5,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              title: 'Cropper',
                            ));
                        if (croppedFile != null) {
                          _imageUserPhoto = croppedFile;
                        }
                        sendUserProfileImages();
                      }
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      Navigator.pop(context);
                      if (image != null) {
                        setState(() {
                          _imageUserPhoto = image;
                        });
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: _imageUserPhoto.path,
                            aspectRatioPresets: Platform.isAndroid
                                ? [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ]
                                : [
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio5x3,
                                    CropAspectRatioPreset.ratio5x4,
                                    CropAspectRatioPreset.ratio7x5,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              title: 'Cropper',
                            ));
                        if (croppedFile != null) {
                          _imageUserPhoto = croppedFile;
                          sendUserProfileImages();
                        } else {
                          sendUserProfileImages();
                        }
                      }
                    }),
              ],
            ),
          );
        });
  }

  void _advertiseImagePopup(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: new Text('Camera'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      Navigator.pop(context);
                      if (image != null) {
                        setState(() {
                          _imageAdvertisementPhoto = image;
                        });
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: _imageAdvertisementPhoto.path,
                            aspectRatioPresets: Platform.isAndroid
                                ? [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ]
                                : [
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio5x3,
                                    CropAspectRatioPreset.ratio5x4,
                                    CropAspectRatioPreset.ratio7x5,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              title: 'Cropper',
                            ));
                        if (croppedFile != null) {
                          _imageAdvertisementPhoto = croppedFile;
                          sendAdvertiseImages();
                        } else {
                          sendAdvertiseImages();
                        }
                      }
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      Navigator.pop(context);
                      if (image != null) {
                        setState(() {
                          _imageAdvertisementPhoto = image;
                        });
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: _imageAdvertisementPhoto.path,
                            aspectRatioPresets: Platform.isAndroid
                                ? [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ]
                                : [
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio5x3,
                                    CropAspectRatioPreset.ratio5x4,
                                    CropAspectRatioPreset.ratio7x5,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Cropper',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            iosUiSettings: IOSUiSettings(
                              title: 'Cropper',
                            ));
                        if (croppedFile != null) {
                          _imageAdvertisementPhoto = croppedFile;
                          sendAdvertiseImages();
                        } else {
                          sendAdvertiseImages();
                        }
                      }
                    }),
              ],
            ),
          );
        });
  }

  sendUserProfileImages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        String img = '';
        List<int> imageBytes = await _imageUserPhoto.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
        print(img);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(Session.MemberId);
        var data = {
          'MemberId': id,
          'imagecode': img,
        };
        print("sss: ${data}");

        Services.updateConclaveUserPhoto(data).then((data) async {
          if (data.ERROR_STATUS == false) {
            pr.hide();
            await prefs.setString(Session.image, data.Data);
            showHHMsg("Update Profile Photo Successfully.");
          } else {
            showHHMsg("Try Again.");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again");
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      showMsg("No Internet Connection.");
    }
  }

  sendAdvertiseImages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        String img = '';
        List<int> imageBytes = await _imageAdvertisementPhoto.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
        print(img);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String id = prefs.getString(Session.MemberId);
        var data = {
          'MemberId': id,
          'imagecode': img,
        };
        print("dateeeee: ${data}");

        Services.updateConclaveAdvertismentPhoto(data).then((data) async {
          if (data.ERROR_STATUS == false) {
            pr.hide();
            await prefs.setString(Session.image, data.Data);
            showHHMsg("Advertisement Profile Photo Successfully.");
          } else {
            showHHMsg("Try Again.");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again");
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      showMsg("No Internet Connection.");
    }
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
                /*Navigator.of(context).pushNamedAndRemoveUntil(
                    '/ConclaveDashboard', (Route<dynamic> route) => false);*/
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _updateProfile() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String chapter = "";
        if (selectType == "BNI Lucknow Member") {
          chapter = selectChapter.name;
        } else if (selectType == "BNI Other Region Member") {
          chapter = edtChapterName.text;
        } else {
          chapter = "";
        }
        print(
            "update Data: ${MemberName},${Mobile},${edtEmail.text},${selectType},${chapter},${edtCmpName.text},${edtBusinessCategory.text},"
            "${edtCity.text},${selectCategory.Id},${edtGSTNo.text},${_isPrivate},${amount}");
        Future res = Services.ConclaveUpdateData(
            MemberId,
            MemberName,
            Mobile,
            edtEmail.text,
            selectType,
            chapter,
            edtCmpName.text,
            edtBusinessCategory.text,
            edtCity.text,
            selectCategory.Id,
            edtGSTNo.text,
            _isPrivate == "true" ? true : false,
            amount);
        res.then((data) async {
          if (data.ERROR_STATUS == false) {
            pr.hide();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(Session.email, edtEmail.text);
            await prefs.setString(Session.company, edtCmpName.text);
            await prefs.setString(Session.category, selectCategory.Id);
            await prefs.setString(Session.city, edtCity.text);
            await prefs.setString(
                Session.categoryName, selectCategory.CategoryName);
            await prefs.setString(Session.type, selectType);
            await prefs.setString(Session.GSTNumber, edtGSTNo.text);
            await prefs.setString(Session.ChapterName, edtChapterName.text);
            await prefs.setString(Session.RegAmt, amount.toString());
            await prefs.setString(Session.isPrivate, _isPrivate);
            Fluttertoast.showToast(
                msg: "Data Update Successfully!!!",
                backgroundColor: Colors.red,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/ConclaveDashboard', (Route<dynamic> route) => false);
          } else {
            pr.hide();
            showMsg("Try Again.");
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
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
    /*if (selectType != "Select Member Type") {
      if (edtCmpName.text != "") {
        if (edtBusinessCategory.text != "") {
          if (edtCity.text != "") {
            if (selectCategoryId != "") {
              if (selectType == "Ex BNI Member" || selectType == "BNI Member") {
                if (edtChapterName.text != "") {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      Future res = Services.ConclaveUpdateData(
                          MemberName,
                          Mobile,
                          edtEmail.text,
                          edtCmpName.text,
                          edtCity.text,
                          selectCategoryId,
                          selectType,
                          edtBusinessCategory.text,
                          edtChapterName.text,
                          _isPrivate);
                      res.then((data) async {
                        pr.hide();
                        if (data.ERROR_STATUS == false) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(Session.email, edtEmail.text);

                          await prefs.setString(
                              Session.company, edtCmpName.text);

                          await prefs.setString(
                              Session.category, selectCategoryId);

                          await prefs.setString(Session.city, edtCity.text);

                          await prefs.setString(
                              Session.categoryName, selectCategoryName);

                          await prefs.setString(Session.type, selectType);
                          await prefs.setString(Session.isPrivate, _isPrivate);
                          showDialogUpdateData("Data Update Successfully");
                        } else {
                          showMsg("Try Again.");
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
                  } on SocketException catch (_) {
                    showMsg("No Internet Connection.");
                  }
                } else {
                  showMsg("Enter Chapter Name.");
                }
              } else {
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    Future res = Services.ConclaveUpdateData(
                        MemberName,
                        Mobile,
                        edtEmail.text,
                        edtCmpName.text,
                        edtCity.text,
                        selectCategoryId,
                        selectType,
                        edtBusinessCategory.text,
                        "",
                        _isPrivate);
                    res.then((data) async {
                      if (data.ERROR_STATUS == false) {
                        pr.hide();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(Session.email, edtEmail.text);

                        await prefs.setString(Session.company, edtCmpName.text);

                        await prefs.setString(
                            Session.category, selectCategoryId);

                        await prefs.setString(Session.city, edtCity.text);

                        await prefs.setString(
                            Session.categoryName, selectCategoryName);

                        await prefs.setString(Session.type, selectType);
                        await prefs.setString(Session.isPrivate, _isPrivate);
                        showDialogUpdateData("Data Update Successfully");
                      } else {
                        pr.hide();
                        showMsg("Try Again.");
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
                } on SocketException catch (_) {
                  showMsg("No Internet Connection.");
                }
              }
            } else {
              showMsg("Select Category.");
            }
          } else {
            showMsg("Enter City Name.");
          }
        } else {
          showMsg("Enter Business Keyword.");
        }
      } else {
        showMsg("Enter Company Name.");
      }
    } else {
      showMsg("Select Member Type.");
    }*/
  }

  onSwitch(bool val) {
    setState(() {
      _isPrivate = val == true ? "true" : "false";
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ConclaveDashboard', (Route<dynamic> route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'My Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
            onTap: () {
              //Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/ConclaveDashboard', (Route<dynamic> route) => false);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: WillPopScope(
            onWillPop: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/ConclaveDashboard', (Route<dynamic> route) => false);
            },
            child: isLoading
                ? LoadingComponent()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              bottom: width * 0.15, left: 25, right: 25),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Text(
                                      "${MemberName}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "${Mobile}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    )),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      color: Colors.white,
                                      child: QrImage(
                                        data: "${qrData}",
                                        size: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Scan this QRCode to get contact information.",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                      textAlign: TextAlign.center,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                      _isPrivate == "true"
                                          ? "Privacy - Private"
                                          : "Privacy - Public",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Transform.scale(
                                  scale: 1.2,
                                  child: Switch(
                                    onChanged: (val) {
                                      onSwitch(val);
                                    },
                                    value: _isPrivate == "true" ? true : false,
                                    activeColor: cnst.appPrimaryMaterialColor,
                                    activeTrackColor:
                                        cnst.appPrimaryMaterialColor[200],
                                    inactiveThumbColor: Colors.grey,
                                    inactiveTrackColor: Colors.grey[400],
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.50,
                                        color: cnst.appPrimaryMaterialColor),
                                    borderRadius: BorderRadius.circular(
                                      0.0,
                                    ),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: <Widget>[
                                        _imageUserPhoto == null
                                            ? MemberImage ==
                                                        "" ||
                                                    MemberImage == null
                                                ? Image.asset(
                                                    'images/no_image.png',
                                                    width: MediaQuery
                                                            .of(context)
                                                        .size
                                                        .width,
                                                    height: 250.0,
                                                    fit: BoxFit.fill)
                                                : FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/loading.gif',
                                                    image:
                                                        IMG_URL + MemberImage,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 250.0,
                                                    fit: BoxFit.fill)
                                            : Image.file(
                                                File(_imageUserPhoto.path),
                                                height: 250.0,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.fill),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 0),
                                          height: 48,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0))),
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        0.0)),
                                            color: cnst.appPrimaryMaterialColor,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            onPressed: () {
                                              _profileImagePopup(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.camera_alt,
                                                    color: Colors.white),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "Upload Profile Image",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.50,
                                        color: cnst.appPrimaryMaterialColor),
                                    borderRadius: BorderRadius.circular(
                                      0.0,
                                    ),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: <Widget>[
                                        _imageAdvertisementPhoto == null
                                            ? AdvertisementImage == "" ||
                                                    AdvertisementImage == null
                                                ? Image.asset(
                                                    'images/no_image.png',
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 250.0,
                                                    fit: BoxFit.fill)
                                                : FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/loading.gif',
                                                    image: IMG_URL +
                                                        AdvertisementImage,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 250.0,
                                                    fit: BoxFit.fill)
                                            : Image.file(
                                                File(_imageAdvertisementPhoto
                                                    .path),
                                                height: 250.0,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.fill),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(top: 0),
                                          height: 48,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0))),
                                          child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        0.0)),
                                            color: cnst.appPrimaryMaterialColor,
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                            onPressed: () {
                                              _advertiseImagePopup(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(Icons.camera_alt,
                                                    color: Colors.white),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    "Advertisement Image",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: edtEmail,
                                    scrollPadding: EdgeInsets.all(0),
                                    decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                        hintText: "Email"),
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                isLoading
                                    ? CircularProgressIndicator()
                                    : Container(
                                        margin: EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.only(left: 20),
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              if (selectType ==
                                                  "Non-BNI Member") {
                                                amount = 110;
                                              } else {
                                                amount = 1500;
                                              }
                                            });
                                            print("Price: ${amount}");
                                          },
                                          items: <String>[
                                            'BNI Lucknow Member',
                                            'BNI Other Region Member',
                                            'Non-BNI Member'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            );
                                          }).toList(),
                                        ))),
                                isLoading
                                    ? CircularProgressIndicator()
                                    : selectType == "BNI Lucknow Member"
                                        ? Container(
                                            margin: EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.only(left: 20),
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                });
                                              },
                                              items: _chapterList
                                                  .map((ChapterClass _chapter) {
                                                return new DropdownMenuItem<
                                                    ChapterClass>(
                                                  value: _chapter,
                                                  child: Text(
                                                    _chapter.name,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                );
                                              }).toList(),
                                            )))
                                        : selectType ==
                                                "BNI Other Region Member"
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: TextFormField(
                                                  controller: edtChapterName,
                                                  scrollPadding:
                                                      EdgeInsets.all(0),
                                                  decoration: InputDecoration(
                                                      border: new OutlineInputBorder(
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      prefixIcon: Icon(
                                                        Icons.category,
                                                        color: cnst
                                                            .appPrimaryMaterialColor,
                                                      ),
                                                      hintText: "Chapter Name"),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                            borderSide: new BorderSide(
                                                color: Colors.black),
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
                                    controller: edtBusinessCategory,
                                    scrollPadding: EdgeInsets.all(0),
                                    decoration: InputDecoration(
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        prefixIcon: Icon(
                                          Icons.business,
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                        hintText: "Business Keywords"),
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
                                            borderSide: new BorderSide(
                                                color: Colors.black),
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
                                isLoading
                                    ? CircularProgressIndicator()
                                    : Container(
                                        margin: EdgeInsets.only(top: 10),
                                        padding: EdgeInsets.only(left: 20),
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 1),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text('${selectCategoryName}'),
                                          value: selectCategory,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectCategory = newValue;
                                              selectCategoryId = newValue.Id;
                                              selectCategoryName =
                                                  newValue.CategoryName;
                                            });
                                          },
                                          items: _categoryList
                                              .map((categoryClass _category) {
                                            return new DropdownMenuItem<
                                                categoryClass>(
                                              value: _category,
                                              child: Text(
                                                _category.CategoryName,
                                                style: TextStyle(
                                                    color: Colors.black),
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
                                            borderSide: new BorderSide(
                                                color: Colors.black),
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
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 0),
                            height: width * 0.11,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(0.0)),
                              color: cnst.appPrimaryMaterialColor,
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                _updateProfile();
                              },
                              child: Text(
                                "Update Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }
}
