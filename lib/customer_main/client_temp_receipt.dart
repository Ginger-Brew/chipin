import 'package:chipin/customer_main/client_receipt_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_appbar.dart';
import '../colors.dart';

class ClientTempReceipt extends StatefulWidget {
  const ClientTempReceipt({Key? key}) : super(key: key);

  @override
  State<ClientTempReceipt> createState() => _ClientTempReceiptState();
}

class _ClientTempReceiptState extends State<ClientTempReceipt> {
  var title;
  var menu;
  var prize;
  var count;
  DateTime? _selectedDate;
  TimeOfDay _initialTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "가게 정보"),
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "상호명",
                        style: TextStyle(
                          fontFamily: "Mainfonts",
                          fontSize: 22,
                          color: Colors.black,)),
                    SizedBox(height: 10,),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          title = text;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //외곽선
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                          });
                        });
                      },
                      child: const Text("날짜 선택"),
                    ),
                    Text(
                        _selectedDate != null
                            ? _selectedDate.toString().split(" ")[0]
                            : "날짜가 아직 선택되지 않음",
                        style: const TextStyle(fontSize: 20)),
                    ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context,
                            initialTime: _initialTime,
                          );
                          if (timeOfDay != null) {
                            setState(() {
                              _initialTime = timeOfDay;
                            });
                          }
                        },
                        child: Text('시간 선택')),
                    Text(
                      '${_initialTime.hour}:${_initialTime.minute}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                        "메뉴명",
                        style: TextStyle(
                          fontFamily: "Mainfonts",
                          fontSize: 22,
                          color: Colors.black,)),
                    SizedBox(height: 10,),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          menu = text;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //외곽선
                      ),
                    ),
                    Text(
                        "가격",
                        style: TextStyle(
                          fontFamily: "Mainfonts",
                          fontSize: 22,
                          color: Colors.black,)),
                    SizedBox(height: 10,),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          prize = text;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //외곽선
                      ),
                    ),
                    Text(
                        "수량",
                        style: TextStyle(
                          fontFamily: "Mainfonts",
                          fontSize: 22,
                          color: Colors.black,)),
                    SizedBox(height: 10,),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          count = text;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), //외곽선
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ClientReceiptAuth(
                                  title: title,
                                  date: _selectedDate,
                                  time: _initialTime,
                                  menu: [menu, prize, count]))
                          );
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Text(
                              '입력하기',
                              style: TextStyle(
                                fontFamily: "Mainfonts",
                                fontSize: 17,
                                color: Colors.white,),
                              textAlign: TextAlign.center
                          ),
                        )
                    )
                  ],
                )
            )
        )
    );
  }
}