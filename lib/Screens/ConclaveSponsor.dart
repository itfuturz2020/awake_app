import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveSponsorComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';

class ConclaveSponsor extends StatefulWidget {
  @override
  _ConclaveSponsorState createState() => _ConclaveSponsorState();
}

class _ConclaveSponsorState extends State<ConclaveSponsor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Sponsor"),
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
          future: Services.getConclaveSponsor(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? snapshot.data.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ConclaveSponsorComponent(
                                snapshot.data[index],
                              );
                            },
                          )
                        : Center(
                child: Container(
                    child: Text("No Data Available",
                        style:
                        TextStyle(fontSize: 17, color: Colors.black54))))
                    : Center(
                child: Container(
                    child: Text("No Data Available",
                        style:
                        TextStyle(fontSize: 17, color: Colors.black54))))
                : LoadingComponent();
          },
        ),
      ),
    );
  }
}
