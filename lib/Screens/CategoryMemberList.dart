import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/CategoryMemberListComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryMemberList extends StatefulWidget {
  var categoryId, childCount;

  CategoryMemberList({this.categoryId, this.childCount});

  @override
  _CategoryMemberListState createState() => _CategoryMemberListState();
}

class _CategoryMemberListState extends State<CategoryMemberList> {
  bool isLoading = true, isSubCatLoading = true;
  List categoryData = [];
  List myData = [];
  List subCategoryList = [];
  int _selectedIndex = 0;
  List list = [];

  @override
  void initState() {
    print("Count :" + widget.childCount);
    //_getCategoryData();
    if (widget.childCount.toString() != "0") {
      _getSubCategoryList();
    } else {
      _getCategoryData(widget.categoryId.toString());
    }
  }

  _getSubCategoryList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetSubCategoryData(widget.categoryId.toString());
        setState(() {
          isSubCatLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list.add({
                "Id": "-1",
                "CategoryName": "All",
                "Image": "",
                "ChildCount": null
              });
              subCategoryList = data;
              for (int i = 0; i < subCategoryList.length; i++) {
                list.add(subCategoryList[i]);
              }
              print("Sub Category: ${list}");
              isSubCatLoading = false;
            });
            _getCategoryData(list[0]["Id"].toString());
          } else {
            setState(() {
              isSubCatLoading = false;
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isSubCatLoading = false;
          });
          print("Error : on Category Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _onSelected(int index, String Id) {
    setState(() => _selectedIndex = index);
    _getCategoryData(Id);
  }

  setData(List data) {
    for (int j = 0; j < data.length; j++) {
      myData.add(data[j]);
    }
  }

  _getCategoryData(String Id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String memberId = preferences.getString(Session.MemberId);
        Future res;

        if (Id == "-1") {
          List d = [];
          for (int i = 1; i < list.length; i++) {
            res = Services.GetCategoryDataById(
                list[i]["Id"].toString(), memberId);
            setState(() {
              isLoading = true;
            });
            res.then((data) async {
              if (data != null && data.length > 0) {
                setState(() {
                  d = data;
                  isLoading = false;
                });
                await setData(d);
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
              print("Error : on Category Data Call $e");
              showMsg("$e");
            });
          }
        } else {
          res = Services.GetCategoryDataById(Id, memberId);
          setState(() {
            isLoading = true;
          });
          res.then((data) async {
            if (data != null && data.length > 0) {
              setState(() {
                myData = data;
                isLoading = false;
              });
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
            print("Error : on Category Data Call $e");
            showMsg("$e");
          });
        }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Category Members"),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              widget.childCount.toString() != "0"
                  ? isSubCatLoading
                      ? LoadingComponent()
                      : Container(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, right: 6),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => _onSelected(
                                        index, list[index]["Id"].toString()),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: _selectedIndex != null &&
                                                  _selectedIndex == index
                                              ? cnst
                                                  .appPrimaryMaterialColor[800]
                                              : cnst
                                                  .appPrimaryMaterialColor[100],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          border: Border.all(
                                              color:
                                                  cnst.appPrimaryMaterialColor[
                                                      50])),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Text(
                                          "${list[index]["CategoryName"]}",
                                          style: TextStyle(
                                              color: _selectedIndex == index
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                  : Container(),
              Expanded(
                child: isLoading
                    ? LoadingComponent()
                    : myData.length > 0
                        ? Container(
                            child: ListView.builder(
                            itemCount: myData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryMemberListComponent(
                                  categoryMemberData: myData[index]);
                            },
                          ))
                        : Center(
                            child: Container(
                                child: Text("No Data Available",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black54)))),
              )
            ],
          )),
    );
  }
}
