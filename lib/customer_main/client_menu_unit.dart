import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientMenuUnit extends StatelessWidget{
  final String title;
  final String prize;
  final String count;
  const ClientMenuUnit(
      {Key? key,
        required this.title,
        required this.prize,
        required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 9,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                        title,
                        style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 17,
                            color: Colors.black)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                        prize,
                        style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 15,
                            color: Colors.amber)
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                  count,
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 20,
                      color: Colors.black)
              ),
            )
          ],
        )
    );
  }

}