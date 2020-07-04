import 'package:awake_app/Common/Constants.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class ConclaveBarterPartnerComponent extends StatefulWidget {
  var partnerData;

  ConclaveBarterPartnerComponent(this.partnerData);

  @override
  _ConclaveBarterPartnerComponentState createState() =>
      _ConclaveBarterPartnerComponentState();
}

class _ConclaveBarterPartnerComponentState
    extends State<ConclaveBarterPartnerComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        elevation: 3,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(6.0),
                    child: widget.partnerData["Logo"].toString() == "" ||
                            widget.partnerData["Logo"] == null
                        ? Image.asset(
                            'images/no_image.png',
                            fit: BoxFit.fill,
                            height: 180,
                            width: MediaQuery.of(context).size.width - 20,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image:
                                IMG_URL +"${widget.partnerData["Logo"]}",
                            fit: BoxFit.fill,
                            height: 180,
                            width: MediaQuery.of(context).size.width - 20,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                  child: Text(
                    "${widget.partnerData["CompanyName"]}",
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 13),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                padding:
                    EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: cnst.appPrimaryMaterialColor.withOpacity(0.9),
                ),
                child: Text(
                  '${widget.partnerData["Name"]}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
