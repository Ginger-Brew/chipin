import 'dart:math';
import 'package:chipin/base_appbar.dart';
import 'package:chipin/colors.dart';
import 'package:flutter/material.dart';
import 'package:chipin/restaurant_point_list/restaurant_point_header.dart';

class RestaurantEarnList extends StatefulWidget {
  const RestaurantEarnList({Key? key}) : super(key: key);

  @override
  State<RestaurantEarnList> createState() => _RestaurantEarnListState();
}

class _RestaurantEarnListState extends State<RestaurantEarnList> {
  var _earnbuttoncolor = MyColor.DARK_YELLOW;
  var _redeembuttoncolor = MyColor.LIGHT_GRAY;
  bool showList1 = true;
  bool showList2 = false;

  void _toggleList1() {
    setState(() {
      showList1 = !showList1;
      showList2 = false;
      _earnbuttoncolor = MyColor.DARK_YELLOW;
      _redeembuttoncolor = MyColor.LIGHT_GRAY;
    });
  }

  void _toggleList2() {
    setState(() {
      showList2 = !showList2;
      showList1 = false;
      _redeembuttoncolor = MyColor.DARK_YELLOW;
      _earnbuttoncolor = MyColor.LIGHT_GRAY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "우리 가게 포인트",
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 43),
              child: Row(
                children: [
                  Expanded(
                    child: PointHeader(
                      title: "누적 후원 포인트",
                      text: "72500",
                      icon: Image.asset('assets/images/coins_black.png'),
                    ),
                  ),
                  Expanded(
                    child: PointHeader(
                      title: "누적 후원 아동 수",
                      text: "10명",
                      icon: Icon(Icons.people_alt_rounded),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 34),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 47.0),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "가게 잔여 포인트",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "3500P",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontFamily: "Mainfonts",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 65),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(child:
                      Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: _toggleList1,
                              child: Text(
                                "사용 내역",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  backgroundColor: _earnbuttoncolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ))))),
                      SizedBox(width: 10,),
                      Expanded(child: Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                              onPressed: _toggleList2,
                              child: Text(
                                "차감 내역",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black45),
                              ),
                              style: ElevatedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  backgroundColor: _redeembuttoncolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  )))))
                    ],
                  ),)),
            SizedBox(height: 22,),
            if (showList1) Expanded(child: _buildList1()),
            if (showList2) Expanded(child: _buildList2()),
          ],
        ),
      ),
    );
  }

  final List<String> earn_menu = <String>[
    '오.칼 (보리밥) 1 외 2',
    '키.칼 (보리밥) 2',
    '오.칼 (보리밥) 1',
    '오.키칼 (보리밥) 2',
    '오.칼 (보리밥) 1 외 1',
    '오.칼 (보리밥) 2',
    '오.칼 (보리밥) 1 외 1',
    '오.칼 (보리밥) 1 외 1',
    '오.칼 (보리밥) 1 외 1',
    '오.칼 (보리밥) 1 외 1'
  ];
  final List<int> earn_point = <int>[
    1750,
    1120,
    630,
    1540,
    1400,
    1260,
    1400,
    1400,
    1400,
    1400
  ];
  final List<String> earn_date = <String>[
    '2023.07.24 17:24',
    '2023.07.24 11:11',
    '2023.07.23 18:48',
    '2023.07.23 15:29',
    '2023.07.23 13:37',
    '2023.07.22 19:48',
    '2023.07.20 15:48',
    '2023.07.17 15:48',
    '2023.07.15 15:48',
    '2023.07.12 15:48',
  ];
  final List<int> earn_point_sum = <int>[
    3500,
    2350,
    1230,
    10600,
    9060,
    7660,
    5010,
    3440,
    1500,
    9000
  ];

  Widget _buildList1() {
    // Replace this with your first list widget implementation
    return ListView.separated(
      itemCount: earn_menu.length,
      itemBuilder: (context, index) =>
          ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.symmetric(horizontal: 40),
            title: Text('${earn_menu[index]}',
              style: TextStyle(fontFamily: "Pretendard",
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),),
            subtitle: Text('${earn_date[index]}', style: TextStyle(fontSize: 10),),
            trailing: Column(children: [
              Text('${earn_point[index]}P', style: TextStyle(
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: MyColor.PRICE)),
              Text('${earn_point_sum[index]}P',
                style: TextStyle(fontSize: 10, color: MyColor.GRAY),)
            ]),
          ), separatorBuilder: (BuildContext context, int index) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30), child: Divider());
    },
    );
  }

  final List<String> redeem_menu = ['키.칼 (보리밥) 1','오.칼 (보리밥) 1','오.칼 (보리밥) 1'];
  final List<int> redeem_point = [-10000,-9000,-9000];
  final List<int> redeem_point_sum = [230,1270,600];
  final List<String> redeem_date = ['2023.07.23 16:56','2023.07.14 12:13','2023.07.02 11:48'];

  Widget _buildList2() {
    // Replace this with your first list widget implementation
    return ListView.separated(
      itemCount: redeem_menu.length,
      itemBuilder: (context, index) =>
          ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.symmetric(horizontal: 40),
            title: Text('${redeem_menu[index]}',
              style: TextStyle(fontFamily: "Pretendard",
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black),),
            subtitle: Text('${redeem_date[index]}', style: TextStyle(fontSize: 10),),
            trailing: Column(children: [
              Text('${redeem_point[index]}P', style: TextStyle(
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF0066FF))),
              Text('${redeem_point_sum[index]}P',
                style: TextStyle(fontSize: 10, color: MyColor.GRAY),)
            ]),
          ), separatorBuilder: (BuildContext context, int index) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30), child: Divider());
    },
    );
  }
}
