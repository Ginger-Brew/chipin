import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_history_unit.dart';

class ClientCalendar extends StatefulWidget {
  const ClientCalendar({Key? key}) : super(key: key);

  @override
  _ClientCalendarState createState() => _ClientCalendarState();
}

class Event {
  String title;
  String date;
  String point;

  Event(this.title, this.date, this.point);
}

class _ClientCalendarState extends State<ClientCalendar>{
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List> eventSource = {
    DateTime.utc(2023, 9, 2) : [Event('정통집', '2023-09-02', '1800P'), Event('정통집', '2023-09-02', '200P')],
    DateTime.utc(2023, 9, 3) : [Event('정통집', '2023-09-03', '1800P')],
    DateTime.utc(2023, 9, 12) : [Event('정통집', '2023-09-03', '1800P')],
    DateTime.utc(2023, 9, 20) : [Event('정통집', '2023-09-03', '1800P')],
  };

  Map<String, List> history = {
    '2023-09-02' : [Event('정통집', '2023.09.02 13:45', '1800P'), Event('별빛맥주', '2023.09.02 15:21', '200P'),
            Event('헤이마오차이', '2023.09.02 18:21', '1200P')],
    '2023-09-03' : [Event('정통집', '2023-09-03', '1800P')],
    '2023-09-12' : [Event('아찌칼국수', '2023.09.12 13:45', '800P')],
    '2023-09-20' : [Event('정통집', '2023-09-03', '1800P')],
  };

  List _getEventsForDay(DateTime day) {
    return eventSource[day] ?? [];
  }

  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  String selectedDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
                    margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
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
                        '23,500P',  //////////////////////////////  파베에서 가져올 데이터
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

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                padding: EdgeInsets.only(bottom: 10),
                child: TableCalendar(
                  locale: 'ko_KR',  //  한글 지원
                  focusedDay: selectedDate,
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2023, 12, 31),
                  daysOfWeekHeight:30,
                  eventLoader: _getEventsForDay,

                  calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, date, dynamic event) {
                    if (event.isNotEmpty) {
                      return Container(
                        width: 43,
                        height: 40,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            color: MyColor.GOLD_YELLOW.withOpacity(0.5),
                            shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                      );
                    }
                  }),

                  // calendarFormat: _calendarFormat,
                  // onFormatChanged: (format) {
                  //   setState(() {
                  //     _calendarFormat = format;
                  //   });
                  // },

                  selectedDayPredicate: (day) {
                    //  selectedDay의 날짜 모양을 바꿔줌
                    return isSameDay(selectedDate, day);
                  },

                  onDaySelected: (DateTime selectedDate, DateTime focusedDate) {
                    // 날짜 선택 시 변수 내용 변경
                    setState((){
                      selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
                      this.selectedDate = selectedDate;
                      this.focusedDate = focusedDate;
                    });
                  },

                  calendarStyle: CalendarStyle(

                    defaultDecoration : BoxDecoration(
                        shape: BoxShape.rectangle
                    ),

                    todayTextStyle : TextStyle(
                        color: Colors.black
                    ),

                    todayDecoration : BoxDecoration(
                      color: Colors.white.withOpacity(0)
                    ),

                    selectedTextStyle : TextStyle(
                        color: Colors.black
                    ),

                    selectedDecoration : BoxDecoration(
                      color: MyColor.GOLD_YELLOW,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    weekendDecoration : const BoxDecoration(shape: BoxShape.rectangle),
                    outsideDecoration : const BoxDecoration(shape: BoxShape.rectangle),
                  ),

                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                        fontFamily: "Mainfonts",
                        fontSize: 25,
                        color: Colors.black
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: Image(
                        width: 40,
                        image: AssetImage('assets/images/calendar_leftbtn.png')
                    ),
                    rightChevronIcon: Image(
                        width: 40,
                        image: AssetImage('assets/images/calendar_rightbtn.png')
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                padding: EdgeInsets.only(bottom: 10),
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
                          "${DateFormat('MM월 dd일 ').format(selectedDate)}${DateFormat.E('ko_KR').format(selectedDate)}요일",
                          style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              color: Colors.grey)
                      ),
                    ),
                    if(history.containsKey(selectedDateString)) listviewBuilder()
                    else
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 30, 10, 30),
                        child: Text(
                          "내역이 없습니다.",
                          style: TextStyle(
                              fontFamily: "Mainfonts",
                              fontSize: 20,
                              color: Colors.grey
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        )
        )
    );
  }

  Widget listviewBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: history[selectedDateString]?.length,
        itemBuilder: (context, index) {
          return ClientHistoryUnit(
              title: '${history[selectedDateString]![index].title}',
              date: '${history[selectedDateString]![index].date}',
              point: '${history[selectedDateString]![index].point}');
        }
    );
  }
}