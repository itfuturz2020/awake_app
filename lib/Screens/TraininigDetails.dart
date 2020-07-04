import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class TraininigDetails extends StatefulWidget {
  var TrainingData;
  TraininigDetails({this.TrainingData});
  @override
  _TraininigDetailsState createState() => _TraininigDetailsState();
}

class _TraininigDetailsState extends State<TraininigDetails> {
  setDate(String datetime) {
    print("d: ${datetime}");
    var dt = datetime.split("-");
    return "${dt[2]} ${getMonth(dt[1])} , ${dt[0]}";
  }

  getMonth(String mon) {
    String month = "";
    switch (mon) {
      case "01":
        month = "January";
        break;
      case "02":
        month = "February";
        break;
      case "03":
        month = "March";
        break;
      case "04":
        month = "April";
        break;
      case "05":
        month = "May";
        break;
      case "06":
        month = "June";
        break;
      case "07":
        month = "July";
        break;
      case "08":
        month = "August";
        break;
      case "09":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }
    return month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Training"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(7),
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(6.0),
              child: widget.TrainingData["Image"] != null
                  ? FadeInImage.assetNetwork(
                      placeholder: 'images/training.png',
                      image: "${cnst.API_URL}${widget.TrainingData["Image"]}",
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "images/training.png",
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Text("${widget.TrainingData["title"]}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text("on ${widget.TrainingData["topic"]}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                      "${widget.TrainingData["description"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Speaker : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text("${widget.TrainingData["speaker"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Trainer : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text("${widget.TrainingData["TrainerName"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Venue : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text("${widget.TrainingData["VenueDetails"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Training Mode : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text("${widget.TrainingData["TrainingMode"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Registration Fee : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                      "${cnst.Inr_Rupee}${widget.TrainingData["amount"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Date : ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                      "${setDate(widget.TrainingData["date"])} -- ${widget.TrainingData["time"]}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
