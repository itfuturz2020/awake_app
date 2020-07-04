import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ChapterMemberComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Pages/ContactService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberDirectory extends StatefulWidget {
  String chapterId, chapterName;

  MemberDirectory({this.chapterId, this.chapterName});

  @override
  _MemberDirectoryState createState() => _MemberDirectoryState();
}

class _MemberDirectoryState extends State<MemberDirectory> {
  TextEditingController searchController = new TextEditingController();

  bool isLoading = true;
  List chapterMemberData = [];
  int chapterMemberCount;
  List searchMemberData = new List();
  bool _isSearching = false, isfirst = false;
  ProgressDialog pr;
  Contact contact;
  String contactName;

  String isExim, isB2B, Chapter;
  TextEditingController _controller = TextEditingController();

  Widget appBarTitle = new Text("Member Directory");

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    print("chapter Name: " + widget.chapterName);
    _getLocalData(widget.chapterName);
    _getChapterMembers();
    getPermission();
  }

  _getLocalData(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isExim = preferences.getString(Session.eximforum);
      isB2B = preferences.getString(Session.b2b);
      Chapter = preferences.getString(Session.ChapterName);
    });
  }

  _getChapterMembers() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String type = '';
        if (isExim == "True" && isB2B == "True")
          type = "all";
        else if (isExim == "True" && isB2B == "False")
          type = "EXIM";
        else if (isExim == "False" && isB2B == "True") type = "B2B";

        Future res = Services.GetChapterMembers(widget.chapterId, type);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null) {
            setState(() {
              chapterMemberData = data;
              chapterMemberCount = chapterMemberData.length;
              print("Data Count: ${chapterMemberCount}");
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
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

  getPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
  }

  _saveAllToContact() async {
    pr.show();
    for (int i = 0; i < chapterMemberData.length; i++) {
      String prefix = "BNI ${widget.chapterName.toString()} ";

      Contact contact = Contact();
      contact.givenName = prefix + chapterMemberData[i]["name"];
      contact.phones = [
        Item(label: "mobile", value: chapterMemberData[i]["mobile"])
      ];
      contact.emails = [
        Item(label: "work", value: chapterMemberData[i]["email"])
      ];
      contact.company = chapterMemberData[i]["categoryname"];
      await ContactService.addContact(contact);
    }
    Fluttertoast.showToast(
        msg: "All Contacts Saved Successfully...",
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG);
    pr.hide();
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
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(top: 13, left: 12, bottom: 13),
                child: Text("Chapter: ${widget.chapterName}",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              )),
          Expanded(
            child: isLoading
                ? LoadingComponent()
                : chapterMemberData.length > 0 && chapterMemberData != null
                    ? searchMemberData.length != 0
                        ? ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: searchMemberData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ChapterMemberComponent(
                                  searchMemberData[index], widget.chapterId);
                            },
                          )
                        : _isSearching && isfirst
                            ? ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: searchMemberData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ChapterMemberComponent(
                                      searchMemberData[index],
                                      widget.chapterId);
                                },
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: chapterMemberData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ChapterMemberComponent(
                                      chapterMemberData[index],
                                      widget.chapterId);
                                },
                              )
                    : Center(
                        child: Container(
                            child: Text("No Data Available",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black54)))),
          ),
          Chapter == widget.chapterName
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: MaterialButton(
                    color: cnst.appPrimaryMaterialColor,
                    minWidth: MediaQuery.of(context).size.width - 20,
                    onPressed: () {
                      _saveAllToContact();
                    },
                    child: Text(
                      "Save All Contacts",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              : Container(),
        ],
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
      for (int i = 0; i < chapterMemberData.length; i++) {
        String name = chapterMemberData[i]["name"];
        String cmpName = chapterMemberData[i]["categoryname"];
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            cmpName.toLowerCase().contains(searchText.toLowerCase())) {
          searchMemberData.add(chapterMemberData[i]);
        }
      }
    }
    setState(() {});
  }
}
