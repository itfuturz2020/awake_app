import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Screens/MemberDirectory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterComponent extends StatefulWidget {
  var chapterData;

  ChapterComponent(this.chapterData);

  @override
  _ChapterComponentState createState() => _ChapterComponentState();
}

class _ChapterComponentState extends State<ChapterComponent> {
  _onDirectoryClick() async {
    setState(() {});
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MemberDirectory(
              chapterId: widget.chapterData["chapterid"],
              chapterName: widget.chapterData["name"]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _onDirectoryClick();
        },
        child: Card(
          color: cnst.appPrimaryMaterialColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("${widget.chapterData["name"]}",
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
