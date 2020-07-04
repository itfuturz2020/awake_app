import 'package:awake_app/Common/Constants.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class ConclaveSponsorComponent extends StatefulWidget {
  var sponsorData;

  ConclaveSponsorComponent(this.sponsorData);

  @override
  _ConclaveSponsorComponentState createState() =>
      _ConclaveSponsorComponentState();
}

class _ConclaveSponsorComponentState extends State<ConclaveSponsorComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        elevation: 3,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(6.0),
                child: widget.sponsorData["Image"].toString() == "" ||
                        widget.sponsorData["Image"] == null
                    ? Image.asset(
                        'images/no_image.png',
                        fit: BoxFit.fill,
                        height: 170,
                        width: MediaQuery.of(context).size.width - 20,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/loading.gif',
                        image:
                            IMG_URL+"${widget.sponsorData["Image"]}",
                        fit: BoxFit.fill,
                        height: 170,
                        width: MediaQuery.of(context).size.width - 20,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
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
                  '${widget.sponsorData["Type"]}',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
