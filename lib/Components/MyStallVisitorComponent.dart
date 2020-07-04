
import 'package:awake_app/Screens/AddContact.dart';
import 'package:awake_app/Screens/ConclaveVisitorProfileView.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MyStallVisitorComponent extends StatefulWidget {
  var stallVisitorData;

  MyStallVisitorComponent({this.stallVisitorData});

  @override
  _MyStallVisitorComponentState createState() =>
      _MyStallVisitorComponentState();
}

class _MyStallVisitorComponentState extends State<MyStallVisitorComponent> {
  _openWhatsapp(mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91${mobile}");
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${widget.stallVisitorData["VisitorName"]}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              Text(
                  "${widget.stallVisitorData["Company"]} -- ${widget.stallVisitorData["CategoryName"]}",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if(widget.stallVisitorData["Email"]==null || widget.stallVisitorData["Email"]==""){
                        Fluttertoast.showToast(
                            msg: "Email Not Found",
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_LONG);
                      }
                      else {
                        launch(
                            'mailto:${widget.stallVisitorData["Email"]
                                .toString()}?subject=&body=');
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
                      launch("tel:" +
                          widget.stallVisitorData["Mobile"].toString());
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
                      _openWhatsapp(widget.stallVisitorData["Mobile"]);
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
                      print("Sata: ${widget.stallVisitorData}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddContact(
                                memberData: widget.stallVisitorData,
                              )));
                    },
                    child: Icon(
                      Icons.person_add,
                      size: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConclaveVisitorProfileView(
                                memberData: widget.stallVisitorData,
                              )));
                    },
                    child: Image.asset(
                      'images/eye.png',
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
