import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Screens/CommitteeMemberDetail.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class ConclaveCommitteeComponent extends StatefulWidget {
  var committeeData;

  ConclaveCommitteeComponent(this.committeeData);

  @override
  _ConclaveCommitteeComponentState createState() =>
      _ConclaveCommitteeComponentState();
}

class _ConclaveCommitteeComponentState
    extends State<ConclaveCommitteeComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => CommitteeMemberDetail(
              widget.committeeData,
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
              widget.committeeData["Image"] == "" ||
                      widget.committeeData["Image"] == null
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
                        image: "${IMG_URL}${widget.committeeData["Image"]}",
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
                            "${widget.committeeData["Name"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Padding(padding: EdgeInsets.only(top: 2)),
                          Text(
                            "${widget.committeeData["Post"]}",
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
      ),
    );
  }
}
