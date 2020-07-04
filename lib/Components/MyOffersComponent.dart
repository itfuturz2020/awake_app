import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Screens/MyOfferDetails.dart';
import 'package:flutter/material.dart';

class MyOffersComponent extends StatefulWidget {
  var offer;
  MyOffersComponent(this.offer);
  @override
  _MyOffersComponentState createState() => _MyOffersComponentState();
}

class _MyOffersComponentState extends State<MyOffersComponent> {
  String day = "", month = "", year = "";

  String setExpiryDate() {
    var dobAy;
    if (widget.offer["ExpiryDate"] != "" ||
        widget.offer["ExpiryDate"] != null) {
      dobAy = widget.offer["ExpiryDate"].toString().split("/");
    }

    setState(() {
      day = dobAy[1].toString();
      month = dobAy[0].toString();
      year = dobAy[2].toString().substring(0, 4);
    });

    return "${day}-${month}-${year}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, '/MyOfferDetails');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyOfferDetails(
                      offerId: widget.offer["Id"].toString(),
                    )));
      },
      child: Container(
        height: 170,
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Card(
          elevation: 3,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: new BorderRadius.circular(6.0),
                child: widget.offer["Image"] == null
                    ? Image.asset(
                        'images/awec.png',
                        fit: BoxFit.fill,
                        height: 170,
                        width: MediaQuery.of(context).size.width - 20,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'images/awec.png',
                        image: "${cnst.IMG_URL}${widget.offer["Image"]}",
                        fit: BoxFit.fill,
                        height: 170,
                        width: MediaQuery.of(context).size.width - 20,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18),
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Text(
                  '${widget.offer["Title"]}',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 17,
                height: 170,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      //_showCupertinoDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15)),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Text(
                          //"Expired on : ${widget.offer["ExpiryDate"]}",
                          widget.offer["ExpiryDate"] == "" ||
                                  widget.offer["ExpiryDate"] == null
                              ? "Expired on : "
                              : "Expired on : ${setExpiryDate()}",
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
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
