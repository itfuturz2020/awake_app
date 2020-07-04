import 'dart:io';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveCommitteeComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';

class ConclaveCommittee extends StatefulWidget {
  @override
  _ConclaveCommitteeState createState() => _ConclaveCommitteeState();
}

class _ConclaveCommitteeState extends State<ConclaveCommittee> {
  bool isLoading = true;
  List _committeList = [];

  @override
  void initState() {
    super.initState();
    _getCommitte();
  }

  _getCommitte() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getConclaveCommittee();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _committeList = data;
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
        showMsg("Something went Wrong!!!");
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Committee"),
        leading: GestureDetector(
          onTap: () {
            //Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading
              ? LoadingComponent()
              : _committeList.length > 0
                  ? ListView.builder(
                      itemCount: _committeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ConclaveCommitteeComponent(_committeList[index]);
                      },
                    )
                  : Center(
                      child: Container(
                          child: Text("No Data Available",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54))))),
    );
  }
}
