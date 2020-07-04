import 'dart:io';

import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/searchMemberComponent.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class ForumMemberDirectory extends StatefulWidget {
  String dashBoardType;

  ForumMemberDirectory({this.dashBoardType});

  @override
  _ForumMemberDirectoryState createState() => _ForumMemberDirectoryState();
}

class _ForumMemberDirectoryState extends State<ForumMemberDirectory> {
  List searchData = new List();
  List searchMemberData = new List();

  ProgressDialog pr;

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

  _searchMember() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetForumMemberList("${widget.dashBoardType}");
        pr.show();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              searchData = data;
            });
            pr.hide();
          } else {
            pr.hide();
            setState(() {
              searchData.clear();
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          pr.hide();
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

  Widget appBarTitle = new Text("Member Directory");

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  TextEditingController _controller = TextEditingController();
  bool _isSearching = false, isfirst = false;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    _searchMember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: searchData.length > 0 && searchData != null
            ? searchMemberData.length != 0
                ? ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: searchMemberData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return searchMemberComponent(searchMemberData[index]);
                    },
                  )
                : _isSearching && isfirst
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: searchMemberData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return searchMemberComponent(searchMemberData[index]);
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: searchData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return searchMemberComponent(searchData[index]);
                        },
                      )
            : Center(
                child: Container(
                    child: Text("No Data Available",
                        style:
                            TextStyle(fontSize: 17, color: Colors.black54)))),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      centerTitle: false,
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(
          icon: icon,
          onPressed: () {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          },
        ),
      ],
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      setState(() {});
      this.appBarTitle = Text("Member Directory");
      _isSearching = false;
      isfirst = false;
      searchMemberData.clear();
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchMemberData.clear();
    if (_isSearching != null) {
      isfirst = true;
      for (int i = 0; i < searchData.length; i++) {
        String name = searchData[i]["name"];
        String cmpName = searchData[i]["companyname"];
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            cmpName.toLowerCase().contains(searchText.toLowerCase())) {
          searchMemberData.add(searchData[i]);
        }
      }
    }
    setState(() {});
  }
}
