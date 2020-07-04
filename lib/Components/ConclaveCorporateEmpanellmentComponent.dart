import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class ConclaveCorporateEmpanellmentComponent extends StatefulWidget {
  var corporateData;
  ConclaveCorporateEmpanellmentComponent(this.corporateData);

  @override
  _ConclaveCorporateEmpanellmentComponentState createState() => _ConclaveCorporateEmpanellmentComponentState();
}

class _ConclaveCorporateEmpanellmentComponentState extends State<ConclaveCorporateEmpanellmentComponent> {
  @override
  Widget build(BuildContext context) {
    print("C Data: ${widget.corporateData}");
    return Container(
      height: 235,
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        elevation: 3,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(6.0),
                child: widget.corporateData["Logo"].toString() == "" ||
                    widget.corporateData["Logo"] == null
                    ? Image.asset(
                  'images/no_image.png',
                  fit: BoxFit.fill,
                  height: 180,
                  width: MediaQuery.of(context).size.width - 20,
                )
                    : FadeInImage.assetNetwork(
                  placeholder: 'assets/loading.gif',
                  image:
                  "IMG_URL${widget.corporateData["Logo"]}",
                  fit: BoxFit.fill,
                  height: 180,
                  width: MediaQuery.of(context).size.width - 20,
                ),
              ),
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
                  "${widget.corporateData["CorporateName"]}",
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
