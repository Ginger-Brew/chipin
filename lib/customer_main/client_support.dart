import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_appbar.dart';
import 'client_drawer_menu.dart';

class ClientSupport extends StatefulWidget {
  const ClientSupport({Key? key}) : super(key: key);

  @override
  State<ClientSupport> createState() => _ClientSupportState();
}

class _ClientSupportState extends State<ClientSupport> {
  // 이미지, 제목, 설명, url
  final info = [];

  getData() async {
    await FirebaseFirestore.instance
        .collection('Support')
        .snapshots()
        .listen((data) {
      info.clear();

      for (var element in data.docs) {
        info.add([element["image"], element["title"], element["subtitle"], element["url"]]);
      }
    });

    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: ClientAppBar(title: "도움의 손길들"),
        endDrawer: const ClientDrawerMenu(),
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 40),
          child: SingleChildScrollView(
              child:FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error!: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }
                  else if (snapshot.hasData) {
                    print("print!");
                    return listViewBuilder(snapshot.data);
                  } else {
                    print("else");
                    return CircularProgressIndicator();
                  }
                },
              ),
          ),
        )
    );
  }

  listViewBuilder(info) {
    return ListView.builder(
        shrinkWrap: true,
      itemCount: info.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Image.network(
                    info[index][0],
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        info[index][1],
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Text(
                        info[index][2].substring(0, 12) + "...",
                        style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ),
                    TextButton(
                        onPressed: (){
                          launchUrl(Uri.parse(info[index][3]));
                        },
                        child: Container(
                          margin: EdgeInsets.zero,
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            color: MyColor.DARK_YELLOW,
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Text(
                              '더보기',
                              style: TextStyle(
                              color: Colors.white
                              ),
                              ),],
                              )
                            )
                        )
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}