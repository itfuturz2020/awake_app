import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Screens/RegionalTeamDetail.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class RegionalTeamComponent extends StatefulWidget {
  var regionalTeam;
  RegionalTeamComponent(this.regionalTeam);
  @override
  _RegionalTeamComponentState createState() => _RegionalTeamComponentState();
}

class _RegionalTeamComponentState extends State<RegionalTeamComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) => RegionalTeamDetail(
                widget.regionalTeam,
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
                widget.regionalTeam["Image"] == "" ||
                        widget.regionalTeam["Image"] == null
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
                          image: "${IMG_URL}${widget.regionalTeam["Image"]}",
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                        ),
                      ),
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
                              "${widget.regionalTeam["MemberName"]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Padding(padding: EdgeInsets.only(top: 2)),
                            Text(
                              "${widget.regionalTeam["Position"]} - ${widget.regionalTeam["ChapterName"]}",
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
                )
              ],
            ),
          ),
        ));
  }
}
