import 'package:awake_app/Screens/TraininigDetails.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class TrainingComponent extends StatefulWidget {
  var TrainingData;
  TrainingComponent(this.TrainingData);
  @override
  _TrainingComponentState createState() => _TrainingComponentState();
}

class _TrainingComponentState extends State<TrainingComponent> {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TraininigDetails(
                      TrainingData: widget.TrainingData,
                    )));
      },
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 190,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(6.0),
                    child: widget.TrainingData["Image"] != null
                        ? FadeInImage.assetNetwork(
                            placeholder: 'images/training.png',
                            image:
                                "${cnst.API_URL}${widget.TrainingData["Image"]}",
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "images/training.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.7),
                            Color.fromRGBO(0, 0, 0, 0.7),
                            Color.fromRGBO(0, 0, 0, 0.7),
                            Color.fromRGBO(0, 0, 0, 0.7)
                          ],
                        ),
                        //borderRadius: new BorderRadius.all(Radius.circular(6)),
                        borderRadius: new BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 5, top: 5),
                      child: Text(
                        '${widget.TrainingData["title"]}',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              child: Text(
                "${setDate(widget.TrainingData["date"])} - ${widget.TrainingData["VenueDetails"]}",
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
