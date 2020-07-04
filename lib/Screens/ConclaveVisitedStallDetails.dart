
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';
class ConclaveVisitedStallDetails extends StatefulWidget {
  var stallData;

  ConclaveVisitedStallDetails({this.stallData});

  @override
  _ConclaveVisitedStallDetailsState createState() =>
      _ConclaveVisitedStallDetailsState();
}

class _ConclaveVisitedStallDetailsState
    extends State<ConclaveVisitedStallDetails> {
  _openWhatsapp(String mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visted Stall Details"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20, left: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Stall No",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.stallData["StallNo"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Stall Name",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.stallData["StallNo"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Mobile",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Text(
                      "${widget.stallData["Mobile"]}",
                      //"${widget.data["Mobile"]}",
                      style: TextStyle(
                          fontSize: 17,
                          color: cnst.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                          onTap: () {
                            launch("tel://${widget.stallData["Mobile"]}");
                          },
                          child: Icon(
                            Icons.phone,
                            size: 22,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          _openWhatsapp("${widget.stallData["Mobile"]}");
                        },
                        child: Image.asset(
                          "images/whatsapp.png",
                          height: 26,
                          width: 26,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          print(
                              "IMG_URL${widget.stallData["VCF"]}");
                        },
                        child: Icon(
                      Icons.person_add,
                      size: 30,
                    ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Company",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.stallData["Company"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${widget.stallData["ShortDescription"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
