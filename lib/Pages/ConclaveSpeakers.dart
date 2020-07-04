import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveSpeakersComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveSpeakers extends StatefulWidget {
  @override
  _ConclaveSpeakersState createState() => _ConclaveSpeakersState();
}

class _ConclaveSpeakersState extends State<ConclaveSpeakers> {
  bool isLoading = true;
  List speakerData = [];

  @override
  void initState() {
    _getSpeakerList();
  }

  List speakerDataStatic = [
    {
      "image": "images/meena.png",
      "name": "Meena Srinivasan",
      "designation":
          "SCION SOCIAL: Co-Founder /  Chief Excellence Office (CEO)",
      "about":
          "Meena Srinivasan, is the Co-founder 8, Chief Excellence Officer of Scion Social, an award-winning global Social Media Marketing firm Ina short span of 7+ years Scion has scaled to support reputed clients all over the world with offices in India, USA and now in Singapore She is the Co-Executive Director of Chennai CBD-A region for BNI She also serves a Board Member on the BNI Foundation, which supports the education of children across the globe through various grants and programs."
    },
    {
      "image": "images/ujjwal.png",
      "name": "Dr. Ujjwal Patni",
      "designation":
          "TOP INDIAN AUTHOR I MOTIVATIONAL SPEAKER I LEADERSHIP COACH ",
      "about":
          "Dr Ujjwal Patni is an International author, motivational speaker, corporate trainer, leadership coach and management consultant. His 7 motivational books are released in 12 Indian languages and two foreign languages. More than 1 million copies of his books have been sold across 18 countries. More than One million people from 30 countries watch \"The Ujjwal Patni show\" released on Ujjwal Patni Mobile app and Youtube channel."
    },
    {
      "image": "images/bhavesh.png",
      "name": "Bhavesh Bhatia",
      "designation": "THE BLIND FOUNDER OF A MULTI-CRORE COMPANY",
      "about":
          "Paralympian, trekker and entrepreneur, visually-impaired Bhavesh Chandubhai Bhatia founded Sunrise Candles, which is run by over 2,280 blind individuals and enjoys a turnover over Rs. 25 crores. He was recently awarded by the Nipman Foundation. His mother said, \"So what if you cannot see the world? Do something so that the world sees you.\" and he did it. "
    },
    {
      "image": "images/gautam.png",
      "name": "Gautam Khetrapal",
      "designation": "TRANSFORMATIONAL SPEAKER I HOST I TRAINER I ENTREPRENEUR",
      "about":
          "Founder of LifePlugin.com and Keynote Speaker in the transformational education space. He've spoken at stages such as Mindvalley, UNESCO, TEDx, Startup Investor Summit. His recent TEDx Talk got over 7 Millions views."
    },
    {
      "image": "images/kumar.png",
      "name": "C K Kumaravel",
      "designation":
          "CEO & CO-FOUNDER, NATURALS SALON & SPA INDIA'S NO.1 SALON",
      "about":
          "He is a believer, a strong believer of the fact that every single Indian must look good! If they look good, they feel good, if they feel good they perform good and if they perforni good they look good. Thus the cycle repeats. Indians are no way inferior to westemers, with a little help on grooming tips & tactics, we can outshine the westerners in terms of looks."
    },
  ];

  _getSpeakerList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile1 = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getSpeakerList();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              speakerData = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingComponent()
        : speakerData.length > 0
            ? Container(
                child: ListView.builder(
                itemCount: speakerData.length,
                itemBuilder: (BuildContext context, int index) {
                  return ConclaveSpeakersComponent(speakerData[index]);
                },
              ))
            : Center(
                child: Container(
                    child: Text("No Data Available",
                        style:
                            TextStyle(fontSize: 17, color: Colors.black54))));
  }
}
