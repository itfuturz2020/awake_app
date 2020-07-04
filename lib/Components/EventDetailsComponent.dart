import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class EventDetailsComponent extends StatefulWidget {
  var date, eventData;
  EventDetailsComponent(this.date, this.eventData);
  @override
  _EventDetailsComponentState createState() => _EventDetailsComponentState();
}

class _EventDetailsComponentState extends State<EventDetailsComponent> {
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "${widget.eventData["Name"]}",
              style: TextStyle(
                  color: cnst.appPrimaryMaterialColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '${widget.eventData["Description"]}',
              textAlign: TextAlign.justify,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.50),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Date & Time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Date : ',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${setDate(widget.date)}',
                        //"${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.eventData["Start_Date"]).toString()))}-${widget.eventData["Start_Date"]}",
                        //' ${widget.eventData["Start_Date"].toString().substring(0, 10)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Time : ',
                        style: TextStyle(
                            color: cnst.appPrimaryMaterialColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${widget.eventData["Time"]}',
                        //"${new DateFormat.MMM().format(DateTime.parse(DateFormat("yyyy-MM-dd").parse(widget.eventData["Start_Date"]).toString()))}-${widget.eventData["Start_Date"]}",
                        //' ${widget.eventData["Start_Date"].toString().substring(0, 10)}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Venue At :',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cnst.appPrimaryMaterialColor,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              '${widget.eventData["Venue"]}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Registration Charges : ${cnst.Inr_Rupee} ${widget.eventData["Fees"]}/-',
              style: TextStyle(
                  color: cnst.appPrimaryMaterialColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Note : Last date of Registration.\n${setDate(widget.eventData["Last_Registration_Date"])}',
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
