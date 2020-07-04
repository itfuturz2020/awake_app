import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class EventComponent extends StatefulWidget {
  var eventData;
  EventComponent(this.eventData);
  @override
  _EventComponentState createState() => _EventComponentState();
}

class _EventComponentState extends State<EventComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            children: <Widget>[
              widget.eventData["Image"] == "" ||
                      widget.eventData["Image"] == null
                  ? Image.asset(
                      "images/WebBanner01.png",
                      fit: BoxFit.cover,
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: "asset/loading.gif",
                      image: "${cnst.IMG_URL}${widget.eventData["Image"]}"),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text("${widget.eventData["Name"]}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "${widget.eventData["Description"]}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "${widget.eventData["Timing"]}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ));
  }
}
