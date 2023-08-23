import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class ClientCalendarUnit extends StatelessWidget {
  const ClientCalendarUnit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 01, 01),
      lastDay: DateTime.utc(2023, 12, 31),
      focusedDay: DateTime.now(),
      locale: 'ko-KR',
    );
  }
}