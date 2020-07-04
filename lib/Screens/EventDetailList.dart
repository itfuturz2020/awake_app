import 'package:awake_app/Components/EventDetailsComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class EventDetailList extends StatefulWidget {
  var date, events;
  EventDetailList({this.date, this.events});
  @override
  _EventDetailListState createState() => _EventDetailListState();
}

class _EventDetailListState extends State<EventDetailList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: widget.events.length > 0
          ? Container(
              height: MediaQuery.of(context).size.height / 1.3,
              margin: EdgeInsets.only(top: 10),
              //height: MediaQuery.of(context).size.height - 75,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                itemHeight: 500,
                autoplay: false,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return EventDetailsComponent(
                      widget.date, widget.events[index]);
                },
                itemCount: widget.events.length,
                pagination: new SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                      color: Colors.grey[300],
                      activeColor: cnst.appPrimaryMaterialColor),
                ),
                viewportFraction: 0.85,
                scale: 0.9,
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
