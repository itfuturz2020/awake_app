
import 'package:awake_app/Screens/ConclaveSpeakerDetails.dart';
import 'package:flutter/material.dart';

class ConclaveSpeakersComponent extends StatefulWidget {
  var speakerData;

  ConclaveSpeakersComponent(this.speakerData);

  @override
  _ConclaveSpeakersComponentState createState() =>
      _ConclaveSpeakersComponentState();
}

class _ConclaveSpeakersComponentState extends State<ConclaveSpeakersComponent> {
  @override
  Widget build(BuildContext context) {
    print("Speaker: ${widget.speakerData}");
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConclaveSpeakerDetails(
                      speakerId: widget.speakerData["Id"].toString(),
                    )));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20),
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/icon_profile_new.png',
                    image: "${widget.speakerData["Image"]}",
                    height: 67,
                    width: 67,
                    //fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.speakerData["SpeakerName"]}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${widget.speakerData["CompanyName"]}: ${widget.speakerData["Designation"]}",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
