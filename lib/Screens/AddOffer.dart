import 'dart:convert';
import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOffer extends StatefulWidget {
  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  TextEditingController edtOfferTitle = new TextEditingController();
  TextEditingController edtDescription = new TextEditingController();

  int selectedIndex = null;
  File _imageOffer;
  bool isLoading = false;
  List packageData = new List();
  ProgressDialog pr;
  int packageId;
  String Amount = "", packageAmount;

  String PaymentStatus = "InProcess";
  String PaymentMessage = "";
  Map paymentResponse;
  Razorpay _razorpay;
  String RazorPayKey, orderId = "";
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
    _getPackageDetails();
    print("Count: " + packageData.length.toString());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getRazorPayKey();
  }

  _getRazorPayKey() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetRazorPayKey();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null) {
            setState(() {
              isLoading = false;
              RazorPayKey = data.Data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Data Not Found",
                gravity: ToastGravity.BOTTOM,
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

  _getPackageDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getPackageDetails();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              packageData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Data Not Found",
                gravity: ToastGravity.BOTTOM,
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

  _addOffer() async {
    print("Title: " + edtOfferTitle.text);
    print("Description: " + edtDescription.text);
    print("Image: " + _imageOffer.toString());
    print("Package Id: " + packageId.toString());
    print("Package Amount: " + packageAmount.toString());
    print("Amount: " + Amount.toString());
    if (edtOfferTitle.text != "" &&
        edtDescription.text != "" &&
        packageId != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();

          String base64Image = "";
          if (_imageOffer != null) {
            List<int> imageBytes = await _imageOffer.readAsBytesSync();
            base64Image = base64Encode(imageBytes);
          }
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String memberId = preferences.getString(Session.MemberId);

          var data = {
            'MemberId': memberId,
            'Title': edtOfferTitle.text,
            'Description': edtDescription.text,
            'imagecode': base64Image,
            'PackageId': packageId.toString(),
            'ReferenceNo': orderId,
          };
          print("Add Offer Data = ${data}");

          Future res = Services.addOffer(data);
          res.then((data) async {
            if (data.ERROR_STATUS == false) {
              pr.hide();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/ConclaveDashboard', (Route<dynamic> route) => false);
            } else {
              pr.hide();
            }
          }, onError: (e) {
            pr.hide();
            print("Error : on Login Call $e");
            showHHMsg("$e");
          });
        } else {
          pr.hide();
          showHHMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.");
      }
    } else {
      showHHMsg("Please Fill All Details.");
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

  showHHMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  void _offerImagePopup(context) {
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
                      if (image != null)
                        setState(() {
                          _imageOffer = image;
                          String img = '';
                          List<int> imageBytes = _imageOffer.readAsBytesSync();
                          String base64Image = base64Encode(imageBytes);
                          img = base64Image;
                          print(img);
                          print(_imageOffer);
                          print(img);
                        });
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Gallery'),
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null)
                        setState(() {
                          _imageOffer = image;
                        });
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  startPayment() async {
    Services.GetOrderIDForPayment(int.parse(Amount), 'ORD1001').then(
        (data) async {
      if (data != null && data.ERROR_STATUS == false) {
        print("order Id---> ${data.Data}");
        setState(() {
          orderId = data.Data;
        });
        var options = {
          'image': '',
          'key': RazorPayKey,
          'order_id': orderId,
          'amount': Amount.toString(),
          'name': 'BIB Evolve',
          'description': 'Offer Payment',
          'prefill': '',
        };
        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint(e);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Payment Gateway Not Open" + data.ORIGINAL_ERROR,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
      }
    }, onError: (e) {
      Fluttertoast.showToast(
          msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("sucess:" + response.toString());
    _addOffer();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("error::: ${response.message}");
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        backgroundColor: cnst.appPrimaryMaterialColor);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        backgroundColor: cnst.appPrimaryMaterialColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Offer"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              //_addOffer();
              startPayment();
              // Navigator.pop(context);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 75,
                padding: EdgeInsets.only(top: 15, left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: edtOfferTitle,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: "Offer Title"),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15, left: 12, right: 12),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: edtDescription,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: "Description"),
                      maxLines: 3,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 12, right: 12),
                child: Text("Select Package", style: TextStyle(fontSize: 16)),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: StaggeredGridView.countBuilder(
                        padding: const EdgeInsets.all(6),
                        crossAxisCount: 3,
                        itemCount: packageData.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                packageId = packageData[index]["Id"];
                                packageAmount = packageData[index]["Amount"]
                                    .toStringAsFixed(0)
                                    .toString();
                                Amount = packageAmount + "00";
                              });
                            },
                            child: Card(
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: selectedIndex == index
                                      ? cnst.appPrimaryMaterialColor
                                      : Colors.white,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        cnst.Inr_Rupee +
                                            " ${packageData[index]["Amount"]}",
                                        style: TextStyle(
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : cnst.appPrimaryMaterialColor,
                                          fontSize: 14,
                                        )),
                                    Text(
                                        "${packageData[index]["Duration"]} days",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: selectedIndex == index
                                                ? Colors.white
                                                : cnst.appPrimaryMaterialColor))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                    ),
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 0.50, color: cnst.appPrimaryMaterialColor),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        _imageOffer == null
                            ? Image.asset(
                                //File("images/awec.png"),
                                "images/awec.png",
                                width: MediaQuery.of(context).size.width,
                                height: 190.0,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_imageOffer.path),
                                width: MediaQuery.of(context).size.width,
                                height: 190.0,
                                fit: BoxFit.cover,
                              ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 10),
                          height: 48,
                          child: MaterialButton(
                            color: cnst.appPrimaryMaterialColor,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              _offerImagePopup(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Select Offer Image",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
