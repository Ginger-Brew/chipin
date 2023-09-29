import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? userid = FirebaseAuth.instance.currentUser!.email;

  // Map<DateTime, List> eventSource = {
  //   DateTime.utc(2023, 09, 02) : [Event('정통집', '2023-09-02', '1800P'), Event('정통집', '2023-09-02', '200P')],
  //   DateTime.utc(2023, 09, 03) : [Event('정통집', '2023-09-03', '1800P')],
  //   DateTime.utc(2023, 09, 12) : [Event('정통집', '2023-09-03', '1800P')],
  //   DateTime.utc(2023, 09, 20) : [Event('정통집', '2023-09-03', '1800P')],
  // };

  Map<DateTime, List<Event>> eventSource = {};
  Map<String, List<List>> history = {};
  int sum = 0;
  var point_format = NumberFormat("###,###P");

  getData() async {
    int i = 0;
    final usercol=FirebaseFirestore.instance.collection("History").doc(userid);
    final snapshot = await usercol.get();

    if(snapshot.exists) {
      final data = snapshot.data() as Map;
      List field = [];
      sum = 0;

      // 년, 월, 일, 시, 분, 이름, 포인트
      while(data[i.toString()] != null) {
        field = data[i.toString()];
        
        String date = "${field[0]}-${field[1]}-${field[2]}";
        String inner_date = "${field[0]}.${field[1]}.${field[2]} ${field[3]}:${field[4]}";
        String point = point_format.format(int.parse(field[6]));
        if(history.containsKey(date)) {
          print(field[5]);
          var tmp = history['tags']?.cast<List>();
          tmp?.add([field[5], inner_date, point]);
        } else {
          print(field[5]);
          history[date] = [[field[5], inner_date, point]];
        }

        sum += int.parse(field[6]);

        var map_date = DateTime.utc(int.parse(field[0]), int.parse(field[1]), int.parse(field[2]));
        if(!eventSource.containsKey(map_date)) {
          eventSource[map_date] = [Event(field[5], date, point)];
        } else {
          List<Event>.from(eventSource[map_date]!).add(Event(field[5], date, point));
        }

        i++;
      }
      print(history);
    }
  }


  List _getEventsForDay(DateTime day) {
    getData();
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
          margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                        point_format.format(sum),
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
              title: '${history[selectedDateString]![index][0]}',
              date: '${history[selectedDateString]![index][1]}',
              point: '${history[selectedDateString]![index][2]}');
        }
    );
  }
}