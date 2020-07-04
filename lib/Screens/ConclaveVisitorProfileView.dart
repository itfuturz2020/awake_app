import 'package:avatar_glow/avatar_glow.dart';
import 'package:awake_app/Screens/AddContact.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ConclaveVisitorProfileView extends StatefulWidget {
  var memberData;

  ConclaveVisitorProfileView({this.memberData});

  @override
  _ConclaveVisitorProfileViewState createState() =>
      _ConclaveVisitorProfileViewState();
}

class _ConclaveVisitorProfileViewState
    extends State<ConclaveVisitorProfileView> {
  _openWhatsApp(String mobile) {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Visitor Details"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    //height:MediaQuery.of(context).size.height/4.5,
                    color: cnst.appPrimaryMaterialColor,
                    height: screen > 550.0 ? screen / 4 : screen / 4.3,
                    width: MediaQuery.of(context).size.width,
                    //child: Image.asset(''),
                  ),
                  clipper: displayDateClipper(),
                ),
                Container(
                    margin: EdgeInsets.only(
                      top: screen > 550.0
                          ? MediaQuery.of(context).size.height / 5.7
                          : MediaQuery.of(context).size.height / 6,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: GestureDetector(
                            onTap: () {},
                            child: AvatarGlow(
                              //startDelay: Duration(milliseconds: 1500),
                              glowColor: cnst.appPrimaryMaterialColor,
                              endRadius: 80.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: Material(
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[100],
                                  child: ClipOval(
                                      child: widget.memberData["Image"] ==
                                                  null ||
                                              widget.memberData["Image"] == ""
                                          ? Image.asset(
                                              "images/awec.png",
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.fill,
                                            )
                                          : FadeInImage.assetNetwork(
                                              placeholder:
                                                  'images/icon_profile_new.png',
                                              image:
                                                  'IMG_URL${widget.memberData["Image"]}',
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.fill,
                                            )),
                                  radius: 50.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          //height > 550.0 ? padding: const EdgeInsets.only(top: 120) : padding: const EdgeInsets.only(top: 120),
                          //padding: const EdgeInsets.only(top: 120),
                          padding: const EdgeInsets.only(top: 20),
                          //padding: const EdgeInsets.only(top: 120),
                          child: Text(
                            "${widget.memberData["VisitorName"]}",
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 15, left: 20, right: 20),
                          child: Text(
                            "Company: ${widget.memberData["Company"]}",
                            style: TextStyle(
                                color: cnst.appPrimaryMaterialColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.email,
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5.2,
                                          child: Text(
                                            "E-mail",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: cnst
                                                    .appPrimaryMaterialColor,
                                                fontWeight: FontWeight.w600),
                                          ))
                                    ],
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${widget.memberData["Email"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: Icon(
                                            Icons.business_center,
                                            color: cnst.appPrimaryMaterialColor,
                                          ),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5.2,
                                            child: Text(
                                              "Category",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: cnst
                                                      .appPrimaryMaterialColor,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      ],
                                    ),
                                    Expanded(
                                        child: Text(
                                      "${widget.memberData["CategoryName"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (widget.memberData["Email"].toString() == "" ||
                                widget.memberData["Email"]
                                        .toString()
                                        .toLowerCase() ==
                                    "null") {
                              Fluttertoast.showToast(
                                  msg: "Email Not Found.",
                                  textColor: cnst.appPrimaryMaterialColor[700],
                                  backgroundColor: Colors.red,
                                  gravity: ToastGravity.CENTER,
                                  toastLength: Toast.LENGTH_SHORT);
                            } else {
                              var url =
                                  'mailto:${widget.memberData["Email"].toString()}?subject=&body=';
                              launch(url);
                            }
                          },
                          child: Image.asset(
                            'images/mail.png',
                            height: 22,
                            width: 32,
                            fit: BoxFit.fill,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launch("tel:" +
                                widget.memberData["Mobile"].toString());
                          },
                          child: Image.asset(
                            'images/icon_circle_phone.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _openWhatsApp(widget.memberData["Mobile"]);
                          },
                          child: Image.asset(
                            'images/icon_Whatsapp.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddContact(
                                          memberData: widget.memberData,
                                        )));
                          },
                          child: Icon(
                            Icons.person_add,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class displayDateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(0.0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
