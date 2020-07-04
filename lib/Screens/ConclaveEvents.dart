import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/CardShareComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ConclaveEvents extends StatefulWidget {
  @override
  _ConclaveEventsState createState() => _ConclaveEventsState();
}

class _ConclaveEventsState extends State<ConclaveEvents> {
  String eventDate;
  List<Tab> tabList = List();

  bool isLoading = true;
  bool IsActivePayment = true;
  int selectedTab = 0;
  List eventData = new List();
  String cardData;
  List evetDate = new List();
  List dateList = new List();
  List data = new List();
  int _selectedIndex = 0;
  List speakerData = [];
  String MemberId = "";
  String Name = "";
  String MemberType = "";
  String ShareMsg =
      "Hello sir,\n My Name is #sender. You can see my digital visiting card from the below link.\n #link \n Regards \n #sender \n Download the App from the below link to make sure your own visiting card. \n #applink";
  bool eventComplete = false;
  List eventTitle = new List();
  int index = 0;
  bool isFirstTime = false, isProfileUpdate = false;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Future initState() {
    getLocalData();
    _getEventDetails();
  }

  _checkProfileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileUpdate = prefs.getString(Session.isProfileUpdate);

    if (profileUpdate == "Profile Updated") {
      isProfileUpdate = true;
    }
    if (isProfileUpdate == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Information !!!"),
            content: new Text(
                "To better experience of Application and for express yourself and your Company please Upadate your Profile !!!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Update Profile",
                  style: TextStyle(color: cnst.appPrimaryMaterialColor),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString(
                      Session.isProfileUpdate, "Profile Updated");
                  isProfileUpdate = true;
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/ConclaveProfile');
                },
              ),
              new FlatButton(
                child: new Text(
                  "Skip",
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
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MemberId = prefs.getString(Session.MemberId);
    Name = prefs.getString(Session.name);
    MemberType = prefs.getString(Session.MemberType);
    print("Member Id: ${MemberId}");
    //_checkProfileStatus();
  }

  _getEventDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile1 = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getEventDetails("1");
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              eventData = data;
              print("Event: ${eventData}");
              print("Address: ${eventData[0]["Address"]}");
              /*dateList.add(
                  _getEventDate(eventData[0]["EventDatesList"][0]["Date"]));
              dateList.add(
                  _getEventDate(eventData[0]["EventDatesList"][1]["Date"]));*/
              eventDate = data[0]["EventDatesList"][0]["Date"];
              _setEventTimes();
              dateList.add(data[0]["EventDatesList"][0]["Date"]);
              dateList.add(data[0]["EventDatesList"][1]["Date"]);
              print("Event dates: ${dateList}");
              index = 0;
              //setTimeEffect();
              _setEventTitle();
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

  _getEventDate(date) {
    var title;
    for (int i = 0; i <= 1; i++) {
      if (dateList[i] == date) {
        var t =
            eventData[0]["EventDatesList"][i]["Title"].toString().split("-");
        title = t[1];
      }
    }
    List month = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    var dt = date.split("-");
    var index = int.parse(dt[1]) - 1;
    return "${dt[2]} ${month[index]}, ${dt[0]} - ${title}";
  }

  _setEventTimes() async {
    print("Selected Event Date: ${eventDate}");
    data = null;
    for (int i = 0; i <= 1; i++) {
      if (eventData[0]["EventDatesList"][i]["Date"] == eventDate) {
        List d = new List();
        d.add(eventData[0]["EventDatesList"][i]["EventDetailList"]);
        print("Data :: ${d}");
        data = d;
      }
      //eventTitle[i]=eventData[0]["EventDatesList"][i]["EventDetailList"][0]["Title"];
    }
    setState(() {});
  }

  _setEventTitle() {
    var title;
    for (int i = 0; i <= 1; i++) {
      print(
          "EventTitle: ${eventData[0]["EventDatesList"][i]["EventDetailList"][0]["Title"]}");
      title = eventData[0]["EventDatesList"][i]["EventDetailList"][0]["Title"];
      var t = title.toString().split("-");
      eventTitle.add(t[1]);
    }
    print("Titles::::: ${eventTitle}");
    setState(() {
      isLoading = false;
    });
  }

  setSpeakerName(speakerId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getSpeakerDetails(speakerId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              speakerData = data;
              return speakerData[0]["SpeakerName"];
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("BNI Evolve"),
          content: new Text(msg),
          actions: <Widget>[
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

  setTimeEffect(time, date) {
    var now = DateTime.now();
    //*9print("Event Time: ${time}");
    var sysYear = now.year;
    var sysMonth = now.month;
    var sysDay = now.day;
    var sysHour = now.hour;
    var sysMinut = now.minute;
    var eventTime = time.toString().split(":");

    var eventDate = date.toString().split("-");
    //print("Phone: date: ${sysDay}  ${sysHour}:${sysMinut}      Event: month ${eventDate[1]} date: ${eventDate[2]}  ${eventTime[0]}:${eventTime[1]}");
    if (int.parse(eventDate[2]) > sysDay) {
      eventComplete = false;
    } else if (int.parse(eventDate[2]) < sysDay) {
      eventComplete = true;
    } else {
      if (int.parse(eventTime[0]) <= sysHour) {
        //eventComplete = true;
        if (int.parse(eventTime[1]) < sysMinut &&
            int.parse(eventTime[0]) == sysHour) {
          eventComplete = true;
        } else if (int.parse(eventTime[1]) > sysMinut &&
            int.parse(eventTime[0]) == sysHour) {
          eventComplete = false;
        } else if (int.parse(eventTime[0]) > sysHour) {
          eventComplete = false;
        } else {
          eventComplete = true;
        }
      } else {
        eventComplete = false;
      }
    }
  }

  _getViewCardId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getViewCardId(memberMobile);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              cardData = data;
              print("Card Id: ${cardData}");
            });
            String profileUrl = cnst.profileUrl.replaceAll("#id", cardData);
            if (await canLaunch(profileUrl)) {
              await launch(profileUrl);
            } else {
              throw 'Could not launch $profileUrl';
            }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events Schedule"),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: isLoading
          ? LoadingComponent()
          : data.length != 0
              ? Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          height: 45,
                          margin: EdgeInsets.only(left: 5, top: 20, bottom: 5),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                            isExpanded: true,
                            hint: Text('Event Date'),
                            value: eventDate,
                            onChanged: (newValue) {
                              setState(() {
                                eventDate = newValue;
                                _setEventTimes();
                                _selectedIndex = 0;
                              });
                            },
                            items: dateList.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  "${_getEventDate(value)}",
                                ),
                                //"${value}",
                              );
                            }).toList(),
                          ))),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(bottom: 15),
                      child: ListView.builder(
                        itemCount: data[0].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          setTimeEffect(
                              data[0][index]["Timing"], data[0][index]["Date"]);
                          return Padding(
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: Center(
                              child: GestureDetector(
                                onTap: () => _onSelected(index),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: _selectedIndex != null &&
                                              _selectedIndex == index
                                          ? cnst.appPrimaryMaterialColor[800]
                                          : eventComplete
                                              ? Colors.green
                                              : cnst
                                                  .appPrimaryMaterialColor[100],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                          color: cnst
                                              .appPrimaryMaterialColor[50])),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4),
                                    child: Text(
                                      "${data[0][index]["Timing"]}",
                                      //"${setTime(data[0][index]["Timing"])}",
                                      style: TextStyle(
                                          color: _selectedIndex != null &&
                                                      _selectedIndex == index ||
                                                  eventComplete
                                              ? Colors.white
                                              : eventComplete
                                                  ? Colors.white
                                                  : Colors.black,
                                          /*color: _selectedIndex != null &&
                                                    _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,*/
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    data[0].length > 0
                        ? Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: MediaQuery.of(context).size.height / 2.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                              Radius.circular(10),
                              //borderRadius: new BorderRadius.circular(6.0),
                            )),
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  child: Image.network(
                                    '${data[0][_selectedIndex]["Image"]}',
                                    width: 600,
                                    height: 400,
                                    fit: BoxFit.fill,
                                    colorBlendMode: BlendMode.dstATop,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromRGBO(0, 0, 0, 0.0),
                                              Color.fromRGBO(0, 0, 0, 0.2),
                                              Color.fromRGBO(0, 0, 0, 0.2),
                                              Color.fromRGBO(0, 0, 0, 0.3)
                                            ],
                                          ),
                                        ),
                                        //height: MediaQuery.of(context).size.height-250,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                35,
                                        //margin: EdgeInsets.symmetric(horizontal: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Text(
                                                "${data[0][_selectedIndex]["EventDetail"]}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            /*    data[0][_selectedIndex]
                                                              ["SpeakerName"] !=
                                                          null ||
                                                      data[0][_selectedIndex]
                                                              ["SpeakerName"] !=
                                                          ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        "Speaker : ${data[0][_selectedIndex]["SpeakerName"]}",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : Container(),*/
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, bottom: 10),
                                              child: Text(
                                                "Event Start At : ${data[0][_selectedIndex]["Timing"]}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ))
                        : Container(),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: RaisedButton(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                elevation: 5,
                                textColor: Colors.white,
                                color: cnst.appPrimaryMaterialColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.share,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("Share",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15)),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  bool val = true;
                                  if (val != null && val == true)
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder:
                                            (BuildContext context, _, __) =>
                                                CardShareComponent(
                                          memberId: MemberId,
                                          memberName: Name,
                                          isRegular: val,
                                          memberType: MemberType,
                                          shareMsg: ShareMsg,
                                          IsActivePayment: IsActivePayment,
                                        ),
                                      ),
                                    );
                                  else
                                    showMsg(
                                        'Your trial is expired please contact to digital card team for renewal.\n\nThank you,\nRegards\nDigital Card');
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            child: RaisedButton(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                elevation: 5,
                                textColor: Colors.white,
                                color: cnst.appPrimaryMaterialColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text("View Card",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15)),
                                    )
                                  ],
                                ),
                                onPressed: () async {
                                  _getViewCardId();
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Container(
                      child: Text("No Data Available",
                          style:
                              TextStyle(fontSize: 17, color: Colors.black54)))),
    );
  }
}
