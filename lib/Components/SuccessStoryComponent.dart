import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessStoryComponent extends StatefulWidget {
  var successStoryData;
  SuccessStoryComponent(this.successStoryData);
  @override
  _SuccessStoryComponentState createState() => _SuccessStoryComponentState();
}

class _SuccessStoryComponentState extends State<SuccessStoryComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget.successStoryData["Image"] == "" ||
                    widget.successStoryData["Image"] == null
                ? Image.asset(
                    "images/success_story.png",
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 130,
                  )
                : FadeInImage.assetNetwork(
                    placeholder: "asset/loading.gif",
                    image:
                        "${cnst.IMG_URL}${widget.successStoryData["Image"]}"),
            Text(
              "${widget.successStoryData["MemberName"]}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Padding(padding: EdgeInsets.only(top: 2)),
            Text(
              "${widget.successStoryData["Position"]} - ${widget.successStoryData["ChapterName"]}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    launch("tel://${widget.successStoryData["Mobile"]}");
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.successStoryData["Email"].toString() == "" ||
                        widget.successStoryData["Email"]
                                .toString()
                                .toLowerCase() ==
                            "null") {
                      Fluttertoast.showToast(
                          msg: "Email Not Found.",
                          textColor: cnst.appPrimaryMaterialColor[700],
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      var url =
                          'mailto:${widget.successStoryData["Email"].toString()}?subject=&body=';
                      launch(url);
                    }
                  },
                  child: Image.asset(
                    'images/mail.png',
                    height: 22,
                    width: 32,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 2)),
            Padding(padding: EdgeInsets.only(top: 2)),
            Text(
              "${widget.successStoryData["SuccessStory"]}",
              //textAlign: TextAlign.center,
              maxLines: 5,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
    /*Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.successStoryData["MemberName"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Padding(padding: EdgeInsets.only(top: 2)),
                        Text(
                          "${widget.successStoryData["Position"]} - ${widget.successStoryData["ChapterName"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 2)),
                        Text(
                          "${widget.successStoryData["SuccessStory"]}",
                          //textAlign: TextAlign.center,
                          maxLines: 5,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    launch("tel://${widget.successStoryData["Mobile"]}");
                  },
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.successStoryData["Email"].toString() == "" ||
                        widget.successStoryData["Email"]
                                .toString()
                                .toLowerCase() ==
                            "null") {
                      Fluttertoast.showToast(
                          msg: "Email Not Found.",
                          textColor: cnst.appPrimaryMaterialColor[700],
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      var url =
                          'mailto:${widget.successStoryData["Email"].toString()}?subject=&body=';
                      launch(url);
                    }
                  },
                  child: Image.asset(
                    'images/mail.png',
                    height: 22,
                    width: 32,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            )*/
  }
}
