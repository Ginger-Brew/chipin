import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/size_utils.dart';

class MenuPage extends StatefulWidget {
  final String restaurantId;
  const MenuPage({
    Key? key,
    required this.restaurantId
  })
      : super(
    key: key,
  );

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  late Future<List<Map<String,dynamic>>> menuDataListFuture;
  
  @override 
  void initState() {
    super.initState();
    menuDataListFuture = fetchMenuData();
  }
  
  Future<List<Map<String,dynamic>>> fetchMenuData() async {
    final restaurantDoc = FirebaseFirestore.instance.collection("Restaurant").doc(widget.restaurantId);
    final menuDocs = await restaurantDoc.collection("Menu").get();

    List<Map<String,dynamic>> menuDataList = [] ;
    for (final doc in menuDocs.docs) {
      menuDataList.add(doc.data());
    }
    return menuDataList;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: menuDataListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(), // 데이터를 기다리는 동안 로딩 표시
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No menu data available.");
              } else {
                final menuDataList = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: getPadding(
                        top: 26,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getVerticalSize(
                              500,
                            ),
                            width: double.maxFinite,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: _buildMenuItems(menuDataList),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );

  }

  List<Widget> _buildMenuItems(List<Map<String, dynamic>> menuDataList) {

    List<Widget> menuItems = [];

    for (int i = 0; i < menuDataList.length; i++) {
      final menuData = menuDataList[i];
      final name = menuData['name'] ?? '';
      final price = menuData['price'] ?? '';

      // ListTile을 만들어 menuItems에 추가
      menuItems.add(
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 17, // 원하는 글꼴 크기로 조정
                  fontWeight: FontWeight.w600, // 글꼴을 두꺼운 스타일로 설정
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 1,
                ),
                child: Text('$price원',overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: Colors.orange// 원하는 글꼴 크기로 조정
                  ),),
              ),
            ],
          ),
        ),
      );

      // 마지막 항목이 아닌 경우 Divider를 추가
      if (i < menuDataList.length - 1) {
        menuItems.add(const Divider());
      }
    }

    return menuItems;
  }
}