import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Screens/FeaturePresentationMemberDetail.dart';
import 'package:flutter/material.dart';

class FeaturePresentationComponent extends StatefulWidget {
  var fPresentation;
  FeaturePresentationComponent(this.fPresentation);
  @override
  _FeaturePresentationComponentState createState() =>
      _FeaturePresentationComponentState();
}

class _FeaturePresentationComponentState
    extends State<FeaturePresentationComponent> {
  setDate(String date) {
    var dt = date.split("/");
    return "${dt[2]} ${setMonth(dt[1].toString())} ${dt[0]}";
  }

  setMonth(String mon) {
    String month = "";
    switch (mon) {
      case "01":
        month = "January";
        break;
      case "02":
        month = "February";
        break;
      case "03":
        month = "March";
        break;
      case "04":
        month = "April";
        break;
      case "05":
        month = "May";
        break;
      case "06":
        month = "June";
        break;
      case "07":
        month = "July";
        break;
      case "08":
        month = "August";
        break;
      case "09":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }
    return month;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) =>
                  FeaturePresentationMemberDetail(
                widget.fPresentation["MemberId"],
              ),
            ),
          );
        },
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.fPresentation["Image"] == "" ||
                        widget.fPresentation["Image"] == null
                    ? ClipOval(
                        child: Image.asset(
                          'images/icon_user.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.fill,
                        ),
                      )
                    : ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'images/icon_user.png',
                          image: "${IMG_URL}${widget.fPresentation["Image"]}",
                          height: 120,
                          width: 120,
                          fit: BoxFit.fill,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 7),
                  child: Text(
                    "${widget.fPresentation["FeaturePresenterName"]}",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "${widget.fPresentation["Category"]} - ${widget.fPresentation["ChapterName"]}",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "${setDate(widget.fPresentation["Date"])}",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
/*
Expanded(
child: Padding(
padding: const EdgeInsets.only(left: 8.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: <Widget>[
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
Text(
"${widget.fPresentation["MemberName"]}",
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.black,
fontWeight: FontWeight.bold,
fontSize: 16),
),
Padding(padding: EdgeInsets.only(top: 2)),
Text(
"${widget.fPresentation["ChapterName"]}",
textAlign: TextAlign.center,
maxLines: 2,
style: TextStyle(
color: Colors.grey[600],
fontSize: 14,
),
),
Padding(padding: EdgeInsets.only(top: 2)),
Text(
"${setDate(widget.fPresentation["Date"])}",
textAlign: TextAlign.center,
maxLines: 2,
style: TextStyle(
color: Colors.grey[600],
fontSize: 14,
),
)
],
),
Icon(Icons.arrow_forward_ios,
color: Colors.grey, size: 19)
],
),
),
)*/
