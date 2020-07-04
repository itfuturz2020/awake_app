import 'dart:io';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveCorporateEmpanellmentComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConclaveCorporateEmpanellment extends StatefulWidget {
  @override
  _ConclaveCorporateEmpanellmentState createState() =>
      _ConclaveCorporateEmpanellmentState();
}

class _ConclaveCorporateEmpanellmentState
    extends State<ConclaveCorporateEmpanellment> {
  bool isLoading = true;
  List empanellmentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCorporateEmpanellmentList();
  }

  _getCorporateEmpanellmentList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getCorporateEmpanellmentList();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              empanellmentList = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Data Not Found",
                gravity: ToastGravity.TOP,
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
        title: Text("Corporate Empanelment"),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List>(
          future: Services.getCorporateEmpanellmentList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? snapshot.data.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ConclaveCorporateEmpanellmentComponent(
                                snapshot.data[index],
                              );
                            },
                          )
                        : Center(
                            child: Container(
                                child: Text("No Data Available",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black54))))
                    : Center(
                        child: Container(
                            child: Text("No Data Available",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black54))))
                : LoadingComponent();
          },
        ),
      ),
      /*body: Container(
        child: ListView.builder(
          itemCount: empanellmentList.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                    title: Text("${empanellmentList[index]["CorporateName"]}")),
                Divider(
                  color: Colors.grey,
                )
              ],
            );
          },
        ),
      ),*/
    );
  }
}
