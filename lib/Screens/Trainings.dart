import 'dart:io';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/TrainingComponent.dart';
import 'package:flutter/material.dart';

class Trainings extends StatefulWidget {
  @override
  _TrainingsState createState() => _TrainingsState();
}

class _TrainingsState extends State<Trainings> {
  bool isLoading = true;
  List TrainingData = [];

  @override
  void initState() {
    _getTrainingData();
  }

  _getTrainingData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetTrainings();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              TrainingData = data;
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
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Trainings"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TrainingData.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                        child: ListView.builder(
                      itemCount: TrainingData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TrainingComponent(TrainingData[index]);
                      },
                    )),
                  )
                : Center(
                    child: Container(
                        child: Text("No Data Available",
                            style: TextStyle(
                                fontSize: 17, color: Colors.black54)))));
  }
}
