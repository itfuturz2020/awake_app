import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Screens/MemberProfile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ConclaveStallComponent extends StatefulWidget {
  var stallData;

  ConclaveStallComponent(this.stallData);

  @override
  _ConclaveStallComponentState createState() => _ConclaveStallComponentState();
}

class _ConclaveStallComponentState extends State<ConclaveStallComponent> {
  _openWhatsapp(String mobile) {
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
                    Text("${widget.stallData["Company"]}",
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
          children: <Widget>[
            widget.stallData["memberData"]["IsPrivate"] != true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (widget.stallData["Email"].toString() == "" ||
                                widget.stallData["Email"]
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
                            launch(
                                "tel:" + widget.stallData["Mobile"].toString());
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
                            _openWhatsapp(widget.stallData["Mobile"]);
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
                                  builder: (context) => MemberProfile(
                                      memberData: widget.stallData,
                                      image: widget.stallData["memberData"]
                                          ["Image"]),
                                ));
                          },
                          child: Image.asset(
                            'images/eye.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemberProfile(
                                      memberData: widget.stallData,
                                      image: widget.stallData["memberData"]
                                          ["Image"]),
                                ));
                          },
                          child: Image.asset(
                            'images/eye.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
