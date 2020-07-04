import 'dart:io';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Components/MyStallVisitorComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyVisitorsList extends StatefulWidget {
  var type;

  MyVisitorsList({this.type});

  @override
  _MyVisitorsListState createState() => _MyVisitorsListState();
}

class _MyVisitorsListState extends State<MyVisitorsList> {
  bool isLoading = false;
  List VisitorList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStallVisitorsList();
    print("Type: ${widget.type}");
  }

  _getStallVisitorsList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String memberId = prefs.getString(Session.MemberId);
      String mobile = prefs.getString(Session.mobile);

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getMyVisitorsList(mobile, widget.type, memberId);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              VisitorList = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Stall Vistor Data Call $e");
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
          automaticallyImplyLeading: true,
          title: Text(
            'Visitor List',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
        ),
        body: isLoading
            ? LoadingComponent()
            : VisitorList.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: VisitorList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MyStallVisitorComponent(
                          stallVisitorData: VisitorList[index]);
                    },
                  )
                : Center(
                    child: Container(
                        child: Text("No Data Available",
                            style: TextStyle(
                                fontSize: 17, color: Colors.black54)))));
  }
}
