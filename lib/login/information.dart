import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Information extends StatefulWidget {
  @override
  ReadAssetFileState createState() {
    ReadAssetFileState pageState = ReadAssetFileState();
    return pageState;
  }
}

class ReadAssetFileState extends State<Information> {
  String filePath = "assets/information.txt";
  String fileText = "";

  readFile() async {
    String text = await rootBundle.loadString(filePath);
    setState(() {
      fileText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("개인정보처리방침")),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: <Widget>[
                Container(width: 10),
                customButton("펼치기", () {
                  readFile();
                })
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey, width: 1)),
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    fileText,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  customTextContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: Text(text),
    );
  }

  customButton(String text, Null Function() onPressed) {
    return ElevatedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 13),
        ),
        onPressed: onPressed,
      );
  }
}