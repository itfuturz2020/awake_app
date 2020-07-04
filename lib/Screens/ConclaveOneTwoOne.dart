import 'package:awake_app/Pages/ReceivedOneTwoOne.dart';
import 'package:awake_app/Pages/SentOneTwoOne.dart';
import 'package:flutter/material.dart';

class ConclaveOneTwoOne extends StatefulWidget {
  @override
  _ConclaveOneTwoOneState createState() => _ConclaveOneTwoOneState();
}

class _ConclaveOneTwoOneState extends State<ConclaveOneTwoOne>
    with SingleTickerProviderStateMixin {
  TabController controller;
  List<Tab> tabBars;
  List<Widget> tabBarViews;

  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(vsync: this, length: 2);
    controller.index = 0;
    tabBars = [
      Tab(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/send.png",
            height: 15,
            width: 15,
            fit: BoxFit.fill,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Sent', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      )),
      Tab(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/receive.png",
            height: 15,
            width: 15,
            fit: BoxFit.fill,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child:
                Text('Receive', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      )),
    ];
    tabBarViews = [SentOneTwoOne(), ReceivedOneTwoOne()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("1-2-1 Invitation"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(controller: controller, tabs: tabBars),
      ),
      body: TabBarView(
        children: tabBarViews,
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
