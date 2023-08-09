import 'package:flutter/material.dart';
import 'package:chipin/colors.dart';
import 'package:chipin/base_shadow.dart';
import 'package:chipin/restaurant_correction/RestaurantInfoCorrection.dart';

class InfoCorrectionButton extends StatelessWidget {
  const InfoCorrectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseShadow(
        container: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.white,
                foregroundColor: MyColor.HOVER),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RestaurantInfoCorrection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "가게 정보 수정하기",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: "Mainfonts"),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/images/correction.png'),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                        flex: 4,
                        child: Text(
                          "최근 수정일 \n2023.05.21.",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: "Pretendard"),
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )));
  }
}
