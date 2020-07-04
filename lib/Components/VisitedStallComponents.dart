import 'package:awake_app/Screens/AddTContact.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitedStallComponents extends StatefulWidget {
  var stallData;

  VisitedStallComponents(this.stallData);

  @override
  _VisitedStallComponentsState createState() => _VisitedStallComponentsState();
}

class _VisitedStallComponentsState extends State<VisitedStallComponents> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cnst.appPrimaryMaterialColor[100],
                ),
                child: Text("${widget.stallData["StallNo"]}"),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.stallData["Name"]}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    Text(
                        "${widget.stallData["Company"]} - ${widget.stallData["Category"]}",
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
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
                      if (widget.stallData["Email"].toString() == "" ||
                          widget.stallData["Email"].toString().toLowerCase() ==
                              "null") {
                        Fluttertoast.showToast(
                            msg: "Email Not Found.",
                            textColor: cnst.appPrimaryMaterialColor[700],
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_SHORT);
                      } else {
                        var url =
                            'mailto:${widget.stallData["Email"].toString()}?subject=&body=';
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
                      launch("tel:" + widget.stallData["Mobile"].toString());
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
                      _openWhatsApp(widget.stallData["Mobile"]);
                    },
                    child: Image.asset(
                      'images/icon_Whatsapp.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTContact(
                                    memberData: widget.stallData,
                                  )));
                    },
                    child: Icon(
                      Icons.person_add,
                      size: 30,
                    ),
                    /*child: Icon(
                      Icons.person_add,
                      size: 30,
                    ),*/
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
