import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BioSheet extends StatefulWidget {
  @override
  _BioSheetState createState() => _BioSheetState();
}

class _BioSheetState extends State<BioSheet>
    with SingleTickerProviderStateMixin {
  TabController controller;
  List<Tab> tabBars;
  List<Widget> tabBarViews;

  // Business Information
  TextEditingController edtBusinessName = new TextEditingController();
  TextEditingController edtProfession = new TextEditingController();
  TextEditingController edtLocation = new TextEditingController();
  TextEditingController edtYears = new TextEditingController();
  TextEditingController edtJobTypes = new TextEditingController();

  // Perosnal Information
  TextEditingController edtSpouse = new TextEditingController();
  TextEditingController edtChildren = new TextEditingController();
  TextEditingController edtAnimals = new TextEditingController();
  TextEditingController edtHobbies = new TextEditingController();
  TextEditingController edtInterest = new TextEditingController();
  TextEditingController edtResidenceCity = new TextEditingController();
  TextEditingController edtHowLong = new TextEditingController();

  // Miscellaneous
  TextEditingController edtBuriningDesire = new TextEditingController();
  TextEditingController edtNoOneKnow = new TextEditingController();
  TextEditingController edtSuccessKey = new TextEditingController();

  Widget Business() {
    return Container(
      padding: EdgeInsets.only(bottom: 50, right: 10, left: 10, top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: edtBusinessName,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Business Name",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Business Name"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtProfession,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Profession",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Profession"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtLocation,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Location",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Location"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtYears,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Years in Business",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Years in Business"),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtJobTypes,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Previous Types of Jobs",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Previous Types of Jobs"),
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget Personal() {
    return Container(
      padding: EdgeInsets.only(bottom: 50, right: 10, left: 10, top: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: edtSpouse,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Spouse",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Spouse"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtChildren,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Children",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Children"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtAnimals,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Animals",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Animals"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtHobbies,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Hobbies",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Hobbies"),
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtInterest,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Activities of Interest",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Activities of Interest"),
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtResidenceCity,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "City of Residence",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "City of Residence"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtHowLong,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "How Long?",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "How Long?"),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget Miscellaneous() {
    return Container(
      padding: EdgeInsets.only(bottom: 50, right: 10, left: 10, top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: edtBusinessName,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Desire",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "My Burning Desire is to..."),
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtProfession,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "No One Know",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "Something no one know about me is"),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            TextFormField(
              controller: edtLocation,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                  labelText: "Key of Success",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  hintText: "My key to Success is..."),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  void initState() {
    // TODO: implement initState
    controller = new TabController(vsync: this, length: 3);
    controller.index = 0;
    tabBars = [
      Tab(
          child:
              Text('Business', style: TextStyle(fontWeight: FontWeight.w600))),
      Tab(
          child:
              Text('Personal', style: TextStyle(fontWeight: FontWeight.w600))),
      Tab(
          child: Text('Miscellaneous',
              style: TextStyle(fontWeight: FontWeight.w600))),
    ];

    tabBarViews = [Business(), Personal(), Miscellaneous()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bio Sheet"),
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
      ),
    );
  }
}
