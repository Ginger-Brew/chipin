import 'package:flutter/material.dart';

List ReportReason =[
  "스팸홍보/도배글입니다.",
  "음란물입니다.",
  "불법정보를 포함하고있습니다.",
  "유해한 내용입니다.",
  "욕설, 혐오 등의 표현이 포함되어 있습니다.",
  "불쾌한 표현이 있습니다."
];

class ReportDetail extends StatefulWidget {
  String childId;

  ReportDetail({super.key, required this.childId});

  @override
  State<StatefulWidget> createState() => _ReportDetailState(childId);
}

class _ReportDetailState extends State<ReportDetail> {
  _ReportDetailState(String childId);

  String _first = ReportReason[0];

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
                      child:Container(
                        margin:EdgeInsets.only(left: 50),
                        child:const Column(
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
                      groupValue: _first,
                      onChanged: (String? value) {
                        setState(() {
                          _first = value!;
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
                      groupValue: _first,
                      onChanged: (String? value) {
                        setState(() {
                          _first = value!;
                        });
                      },
                    ),
                  ),ListTile(
                    //ListTile - title에는 내용,
                    //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                    title: Text(ReportReason[2]),
                    leading: Radio<String>(
                      value: ReportReason[2],
                      groupValue: _first,
                      onChanged: (String? value) {
                        setState(() {
                          _first = value!;
                        });
                      },
                    ),
                  ),ListTile(
                    //ListTile - title에는 내용,
                    //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                    title: Text(ReportReason[3]),
                    leading: Radio<String>(
                      value: ReportReason[3],
                      groupValue: _first,
                      onChanged: (String? value) {
                        setState(() {
                          _first = value!;
                        });
                      },
                    ),
                  ),ListTile(
                    //ListTile - title에는 내용,
                    //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                    title: Text(ReportReason[4]),
                    leading: Radio<String>(
                      value: ReportReason[4],
                      groupValue: _first,
                      onChanged: (String? value) {
                        setState(() {
                          _first = value!;
                        });
                      },
                    ),
                  ),ListTile(
                    //ListTile - title에는 내용,
                    //leading or trailing에 체크박스나 더보기와 같은 아이콘을 넣는다.
                    title: Text(ReportReason[5]),
                    leading: Radio<String>(
                      value: ReportReason[5],
                      groupValue: _first,
                      onChanged: (String? value) {
                        setState(() {
                          _first = value!;
                        });
                      },
                    ),
                  ),
                ],
              )
                ],
              ),
            ),
          ),
        );
  }
}
