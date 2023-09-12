import 'package:flutter/material.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_print_unit.dart';

class ClientCalendar extends StatefulWidget {
  const ClientCalendar({Key? key}) : super(key: key);

  @override
  _ClientCalendarState createState() => _ClientCalendarState();
}

class _ClientCalendarState extends State<ClientCalendar> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "내 누적 포인트"),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Text(
                        '누적 포인트',
                        style: TextStyle(
                            fontFamily: "Mainfonts",
                            fontSize: 25,
                            color: Colors.black)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Text(
                        '23,500P',
                        style: TextStyle(
                            fontFamily: "Mainfonts",
                            fontSize: 25,
                            color: Colors.black)
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                height: 1,
                width: double.maxFinite,
                color: MyColor.DIVIDER,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 40, 10, 20),
                width: double.infinity,
                child: Text(
                    '전체내역',
                    style: TextStyle(
                        fontFamily: "Mainfonts",
                        fontSize: 25,
                        color: Colors.black)
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                    width: double.infinity,
                    image: AssetImage('assets/images/calendar.png')
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
                      width: double.infinity,
                      child: Text(
                          '4월 30일 수요일',
                          style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              color: Colors.grey)
                      ),
                    ),
                    ClientPrintUnit(title: '정통집', date: '2023.07.24 17:24', point: '1800P',)
                  ],
                ),
              )
            ],
          ),
        )
        )
    );
  }
}