import 'package:awake_app/Common/Constants.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class FoodStallItemComponent extends StatefulWidget {
  var foodItemData;

  FoodStallItemComponent(this.foodItemData);

  @override
  _FoodStallItemComponentState createState() => _FoodStallItemComponentState();
}

class _FoodStallItemComponentState extends State<FoodStallItemComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.foodItemData["Image"] != "" &&
                    widget.foodItemData["Image"] != null
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: IMG_URL +
                        widget.foodItemData["Image"],
                    height: 125,
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                  'images/no_image.png',
                  height: 125,
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.fill,
                ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              "${widget.foodItemData["ItemName"]}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Padding(padding: EdgeInsets.only(top: 2)),
            Text(
              "${cnst.Inr_Rupee} ${widget.foodItemData["Price"]}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
