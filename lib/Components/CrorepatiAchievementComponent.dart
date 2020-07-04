import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Screens/CrorepatiAchievementDetail.dart';
import 'package:flutter/material.dart';

class CrorepatiAchievementComponent extends StatefulWidget {
  var crorepatiData;
  CrorepatiAchievementComponent(this.crorepatiData);
  @override
  _CrorepatiAchievementComponentState createState() =>
      _CrorepatiAchievementComponentState();
}

class _CrorepatiAchievementComponentState
    extends State<CrorepatiAchievementComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) =>
                  CrorepatiAchievementDetail(
                widget.crorepatiData,
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
                widget.crorepatiData["Image"] == "" ||
                        widget.crorepatiData["Image"] == null
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
                          image: "${IMG_URL}${widget.crorepatiData["Image"]}",
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
                                "${widget.crorepatiData["Name"]}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Padding(padding: EdgeInsets.only(top: 2)),
                              Text(
                                "${widget.crorepatiData["Company"]} - ${widget.crorepatiData["ChapterName"]}",
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
