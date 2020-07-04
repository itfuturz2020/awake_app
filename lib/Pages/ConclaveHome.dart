import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ConclaveHome extends StatefulWidget {
  @override
  _ConclaveHomeState createState() => _ConclaveHomeState();
}

class _ConclaveHomeState extends State<ConclaveHome> {
  bool isLoading = true;
  int _current = 0;
  List _advertisementData = [];
  final List<Menu> _allMenuList = Menu.allMenuItems();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProgressDialog pr;

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
    _getBanner();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  _getBanner() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetBanners();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            List images = data;
            for (int i = 0; i < images.length; i++) {
              setState(() {
                _advertisementData.add(images[i]["Image"]);
              });
            }
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              _advertisementData.clear();
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
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  Widget _getMenuItem(BuildContext context, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: 3,
      child: SlideAnimation(
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/${_allMenuList[index].PageName}');
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    //  bottom: BorderSide(width: ,color: Colors.black54),
                    top: BorderSide(width: 0.1, color: Colors.black)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(width: 0.2, color: Colors.grey[600]),
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/" + _allMenuList[index].Icon,
                        width: 30,
                        height: 30,
                        color: cnst.appPrimaryMaterialColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(
                          _allMenuList[index].IconName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
    return SingleChildScrollView(
      child: Column(
        key: _scaffoldKey,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 7),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/SearchMember');
                      },
                      child: Container(
                        height: 45,
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color(0xffF0F1F5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              'Search',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          !isLoading
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    CarouselSlider(
                      height: 180,
                      viewportFraction: 0.9,
                      autoPlayAnimationDuration: Duration(milliseconds: 1500),
                      reverse: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlay: true,
                      onPageChanged: (index) {
                        setState(() {
                          _current = index;
                        });
                      },
                      items: _advertisementData.map((i) {
                        return Builder(builder: (BuildContext context) {
                          return FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: "http://evolve.buyinbni.in/" + i,
                            height: 125,
                            width: MediaQuery.of(context).size.width / 1.13,
                            fit: BoxFit.fill,
                          );
                          /*Image.asset(i,
                        width: MediaQuery.of(context).size.width);*/
                        });
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(
                        _advertisementData,
                        (index, url) {
                          return Container(
                            width: 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: _current == index
                                    ? Colors.black
                                    : Colors.grey.shade400),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 180,
                  child: Center(child: CircularProgressIndicator())),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[500], width: 0.3))),
              child: AnimationLimiter(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: _getMenuItem,
                  itemCount: _allMenuList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 2.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Menu {
  final String Icon;
  final String IconName;
  final String PageName;

  Menu({this.Icon, this.IconName, this.PageName});

  static List<Menu> allMenuItems() {
    var listofmenus = new List<Menu>();

    listofmenus.add(new Menu(
        Icon: "events.png", IconName: "Trainings", PageName: "Trainings"));
    listofmenus.add(new Menu(
        Icon: "meeting.png", IconName: "1-2-1", PageName: "ConclaveOneTwoOne"));
    listofmenus.add(new Menu(
        Icon: "directory.png",
        IconName: "Directory",
        PageName: "ConclaveDirectory"));
    listofmenus.add(new Menu(
        Icon: "speakers.png",
        IconName: "Feature Presentation",
        PageName: "FeaturePresentation"));
    listofmenus.add(new Menu(
        Icon: "category.png",
        IconName: "Category",
        PageName: "ConclaveCategory"));
    listofmenus.add(new Menu(
        Icon: "exhibitor.png",
        IconName: "Success Stories",
        PageName: "SuccessStories"));
    listofmenus.add(new Menu(
        Icon: "committee.png",
        IconName: "Achievements",
        PageName: "Achievements"));
    listofmenus.add(
        new Menu(Icon: "partners.png", IconName: "Events", PageName: "Events"));
    listofmenus.add(
        new Menu(Icon: "sponsors.png", IconName: "Offers", PageName: "Offers"));
    return listofmenus;
  }
}
