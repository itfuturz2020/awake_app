import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Screens/EventDetailList.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with TickerProviderStateMixin {
  bool isLoading = true;
  List eventData = [];
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  List _selectedEvents;
  int _currentIndex = 0;
  CalendarController _calendarController;
  AnimationController _controller;
  @override
  void initState() {
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _calendarController = new CalendarController();
    _getEventData();
  }

  _getEventData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var now = new DateTime.now();
        String sdate = DateTime(now.year, 1, 1).toString().substring(0, 10);
        String edate = DateTime(now.year, 12, 31).toString().substring(0, 10);
        Future res = Services.GetEventData(sdate, edate);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              // eventData = data;
              isLoading = false;
            });
            _events = {};
            for (int i = 0; i < data.length; i++) {
              _events.addAll({
                DateTime.parse(data[i]["Date"].toString()): data[i]
                    ["BIBEventDatesList"]
              });
            }
            _selectedEvents = _events[_selectedDay] ?? [];
            _visibleEvents = _events;

            _controller = AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 100),
            );
            _controller.forward();
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Chapter Data Call $e");
          showMsg("$e");
        });
      } else {
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });

    /*ifx (events.length == 1) {
      showEventDialog(_selectedEvents);
    } else if (events.length > 1) {
      Navigator.pushNamed(context, '/MultipleEventList');
    }*/
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'en_US',
      events: _visibleEvents,
      //holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        /*CalendarFormat.twoWeeks: '2 weeks',
        CalendarFormat.week: 'Week',*/
      },
      calendarStyle: CalendarStyle(
        selectedColor: cnst.appPrimaryMaterialColor,
        todayColor: cnst.appPrimaryMaterialColor[200],
        markersColor: Colors.deepOrange,
        //markersMaxAmount: 7,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: cnst.appPrimaryMaterialColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      calendarController: _calendarController,
    );
  }

  Widget _buildEventList() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView(
        children: _selectedEvents
            .map((event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(event["Name"]),
                        Text(event["Venue"]),
                      ],
                    ),
                    onTap: () {
                      String selectedDate =
                          _selectedDay.toString().substring(0, 10);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailList(
                            date: selectedDate,
                            events: _selectedEvents,
                          ),
                        ),
                      );
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      print(first);
      print(last);

      /*getDashboardData(chapterId == "null" ? "0" : chapterId,
          first.toString().substring(0, 10), last.toString().substring(0, 10));

      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          Expanded(child: _buildEventList()),
        ],
      ),
      /*isLoading
            ? Center(child: CircularProgressIndicator())
            : eventData.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                        child: ListView.builder(
                      itemCount: eventData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EventComponent(eventData[index]);
                      },
                    )),
                  )
                : Center(
                    child: Container(
                        child: Text("No Data Available",
                            style: TextStyle(
                                fontSize: 17, color: Colors.black54))))*/
    );
  }
}
