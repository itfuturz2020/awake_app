import 'dart:io';

import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/FeaturePresentationComponent.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class FeaturePresentation extends StatefulWidget {
  @override
  _FeaturePresentationState createState() => _FeaturePresentationState();
}

class _FeaturePresentationState extends State<FeaturePresentation> {
  bool isLoading = true;
  List fPresentation = [];

  @override
  void initState() {
    _getFeaturedPresentation();
  }

  _getFeaturedPresentation() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetFeaturePresentation();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              fPresentation = data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feature Presentation"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : fPresentation.length > 0
                ? Container(
                    child: ListView.builder(
                    itemCount: fPresentation.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FeaturePresentationComponent(fPresentation[index]);
                    },
                  ))
                : Center(
                    child: Container(
                        child: Text("No Data Available",
                            style: TextStyle(
                                fontSize: 17, color: Colors.black54)))));
  }
}
