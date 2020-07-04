
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Screens/FoodStallItem.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class ConclaveFoodStallComponent extends StatefulWidget {
  var foodStallData;

  ConclaveFoodStallComponent(this.foodStallData);

  @override
  _ConclaveFoodStallComponentState createState() =>
      _ConclaveFoodStallComponentState();
}

class _ConclaveFoodStallComponentState
    extends State<ConclaveFoodStallComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodStallItem(
              Id: widget.foodStallData["Id"].toString(),
              Name: widget.foodStallData["FoodStallName"].toString(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              widget.foodStallData["Logo"] != "" &&
                      widget.foodStallData["Logo"] != null
                  ? Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: cnst.appPrimaryMaterialColor),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: IMG_URL +
                                widget.foodStallData["Logo"],
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        'images/icon_user.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 0)),
                      Text(
                        "${widget.foodStallData["FoodStallName"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Padding(padding: EdgeInsets.only(top: 2)),
                      Text(
                        "${widget.foodStallData["CompanyName"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
