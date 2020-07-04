import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Screens/GoldAchievementDetail.dart';
import 'package:flutter/material.dart';

class GoldAchievementComponent extends StatefulWidget {
  var goldData;
  GoldAchievementComponent(this.goldData);
  @override
  _GoldAchievementComponentState createState() =>
      _GoldAchievementComponentState();
}

class _GoldAchievementComponentState extends State<GoldAchievementComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) =>
                  GoldAchievementDetail(
                widget.goldData,
              ),
            ),
          );
        },
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.goldData["Image"] == "" ||
                        widget.goldData["Image"] == null
                    ? ClipOval(
                        child: Image.asset(
                          'images/icon_user.png',
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        ),
                      )
                    : ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'images/icon_user.png',
                          image: "${IMG_URL}${widget.goldData["Image"]}",
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${widget.goldData["Name"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(top: 2)),
                              Text(
                                "${widget.goldData["Company"]} - ${widget.goldData["ChapterName"]}",
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey, size: 19)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
