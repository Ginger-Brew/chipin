import 'package:chipin/child/service/report_service.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../model/model_report.dart';

List ReportReason = [
  "스팸홍보/도배글입니다.",
  "음란물입니다.",
  "불법정보를 포함하고있습니다.",
  "유해한 내용입니다.",
  "욕설, 혐오 등의 표현이 포함되어 있습니다.",
  "불쾌한 표현이 있습니다."
];

class ReportDetail extends StatefulWidget {
  Review review;

  ReportDetail({super.key, required this.review});

  @override
  State<StatefulWidget> createState() => _ReportDetailState(review: review);
}

class _ReportDetailState extends State<ReportDetail> {
  Review review;
  _ReportDetailState({required this.review});

  String _reason = ReportReason[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
        Expanded(
          child: Column(
              children: [
              Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "리뷰 신고하기",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Text(
                        "리뷰 사유를 선택해주세요.",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                      )
                    ]),
              )
          ),
          Column(
            children: <Widget>[
              ListTile(
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text(ReportReason[0]),
                leading: Radio<String>(
                  value: ReportReason[0],
                  groupValue: _reason,
                  onChanged: (String? value) {
                    setState(() {
                      _reason = value!;
                    });
                  },
                ),
              ),
              ListTile(
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text(ReportReason[1]),
                leading: Radio<String>(
                  value: ReportReason[1],
                  groupValue: _reason,
                  onChanged: (String? value) {
                    setState(() {
                      _reason = value!;
                    });
                  },
                ),
              ), ListTile(
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text(ReportReason[2]),
                leading: Radio<String>(
                  value: ReportReason[2],
                  groupValue: _reason,
                  onChanged: (String? value) {
                    setState(() {
                      _reason = value!;
                    });
                  },
                ),
              ), ListTile(
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text(ReportReason[3]),
                leading: Radio<String>(
                  value: ReportReason[3],
                  groupValue: _reason,
                  onChanged: (String? value) {
                    setState(() {
                      _reason = value!;
                    });
                  },
                ),
              ), ListTile(
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text(ReportReason[4]),
                leading: Radio<String>(
                  value: ReportReason[4],
                  groupValue: _reason,
                  onChanged: (String? value) {
                    setState(() {
                      _reason = value!;
                    });
                  },
                ),
              ), ListTile(
                //ListTile - title에는 내용,
                //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                title: Text(ReportReason[5]),
                leading: Radio<String>(
                  value: ReportReason[5],
                  groupValue: _reason,
                  onChanged: (String? value) {
                    setState(() {
                      _reason = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColor.DARK_YELLOW,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                ReportService reportservice = new ReportService();
                reportservice.createReport(_reason, review);
                reportservice.checkReportCount(review);
                Navigator.pop(context);
              },
              child: Text(
                '신고하기',
                style: TextStyle(fontFamily: "Pretendard", fontSize: 16),
              ),
            ),
          )
          ],
        ),
      ),
    ),);
  }
}
