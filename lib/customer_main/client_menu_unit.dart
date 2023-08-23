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
      margin: EdgeInsets.fromLTRB(40, 20, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      title,
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 15,
                        color: Colors.black,)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                        prize,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 12,
                          color: Colors.amber,)
                    ),
                  )
                ],
              ),
          Text(
                count,
                style: TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 17,
                  color: Colors.black,)
            ),
        ],
      ),
    );
  }

}