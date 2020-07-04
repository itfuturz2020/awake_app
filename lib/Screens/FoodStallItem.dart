import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/FoodStallItemComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';

class FoodStallItem extends StatefulWidget {
  String Id, Name;

  FoodStallItem({this.Id, this.Name});

  @override
  _FoodStallItemState createState() => _FoodStallItemState();
}

class _FoodStallItemState extends State<FoodStallItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("${widget.Name}"),
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
          future: Services.getConclaveFoodStallItem(widget.Id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(snapshot.data.length, (index) {
                          return FoodStallItemComponent(snapshot.data[index]);
                        }),
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
