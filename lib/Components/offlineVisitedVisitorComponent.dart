
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class offVisitedVisitorComponent extends StatefulWidget {
  var visitorData;

  offVisitedVisitorComponent(this.visitorData);

  @override
  _offVisitedVisitorComponentState createState() =>
      _offVisitedVisitorComponentState();
}

class _offVisitedVisitorComponentState
    extends State<offVisitedVisitorComponent> {
  _openWhatsApp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.only(top: 5, right: 10, bottom: 5),
        child: ExpansionTile(
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.asset(
                    'images/no_image.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${widget.visitorData.name}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      Text(
                          "${widget.visitorData.company} - ${widget.visitorData.category}",
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (widget.visitorData.email.toString() == "" ||
                          widget.visitorData.email.toString().toLowerCase() ==
                              "null") {
                        Fluttertoast.showToast(
                            msg: "Email Not Found.",
                            textColor: cnst.appPrimaryMaterialColor[700],
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_SHORT);
                      } else {
                        var url =
                            'mailto:${widget.visitorData.email.toString()}?subject=&body=';
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
                  GestureDetector(
                    onTap: () {
                      launch(
                          "tel:" + widget.visitorData.mobileNumber.toString());
                    },
                    child: Image.asset(
                      'images/icon_circle_phone.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _openWhatsApp(widget.visitorData.mobileNumber);
                    },
                    child: Image.asset(
                      'images/icon_Whatsapp.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
