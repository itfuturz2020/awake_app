
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveFoodStallComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';

class ConclaveFoodStall extends StatefulWidget {
  @override
  _ConclaveFoodStallState createState() => _ConclaveFoodStallState();
}

class _ConclaveFoodStallState extends State<ConclaveFoodStall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Food Stall"),
        leading: GestureDetector(
          onTap: () {
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
        child: FutureBuilder<List>(
          future: Services.getConclaveFoodStall(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ConclaveFoodStallComponent(
                            snapshot.data[index],
                          );
                        },
                      )
                    : Center(
                child: Container(
                    child: Text("No Data Available",
                        style: TextStyle(
                            fontSize: 17, color: Colors.black54))))
                : LoadingComponent();
          },
        ),
      ),
    );
  }
}
