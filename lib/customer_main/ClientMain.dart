import 'package:carousel_slider/carousel_slider.dart';
import 'package:chipin/customer_main/client_temp_receipt.dart';
import 'package:chipin/customer_main/client_text_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base_appbar.dart';
import '../colors.dart';
import 'client_calendar.dart';
import 'client_support.dart';
import 'client_yellow_btn.dart';

class ClientMain extends StatefulWidget {
  const ClientMain({Key? key}) : super(key: key);

  @override
  State<ClientMain> createState() => _ClientMainState();
}

class _ClientMainState extends State<ClientMain> {
  XFile? _image;  // 이미지 저장 변수
  final ImagePicker picker = ImagePicker();  //  ImagePicker 변수
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    if (image == null) return;
    setState(() {
      _image = XFile(image.path); // 가져온 이미지를 _image에 저장
    });
  }

  String? userid = FirebaseAuth.instance.currentUser!.email;

  // carousel slider 변수들
  int _current = 0;
  final CarouselController _controller = CarouselController();
  var point_format = NumberFormat('###,###,###P');

  var result = [];
  var point = "";
  var number = "";
  var percent_point = 0.0;
  var percent_number = 0.0;
  var tmp = 0.0;

  getData() async {
    final usercol=FirebaseFirestore.instance.collection("Client").doc(userid);
    await usercol.get().then((value) => { //값을 읽으면서, 그 값을 변수로 넣는 부분
      point = point_format.format(int.parse(value['point'])),
      number = value['number']+"회",
      tmp = int.parse(value['point'])/30000,
      if(tmp >= 1.0) {
        percent_point = 1.0
      } else {
        percent_point = double.parse(tmp.toStringAsFixed(2))
      },

      tmp = double.parse(value['point'])/10,
      if(tmp > 1.0) {
        percent_number = 1.0
      } else {
        percent_number = double.parse(tmp.toStringAsFixed(2))
      },
    });

    await FirebaseFirestore.instance
        .collection('Support')
        .snapshots()
        .listen((data) {
          result.clear();

      for (var element in data.docs) {
        result.add([element["image"], element["title"], element["subtitle"], element["url"]]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "십시일반"),
        body: Container(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 100, 0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ClientSupport())
                        );
                      },
                      child: ClientTextBtn(
                        imgPath: "handhearticon.png",
                        title: "도움의 손길들",
                      ),
                    ),
                  ),

                  SizedBox(
                    child: sliderWidget(),
                  ),
                  sliderIndicator(),

                  Container(
                    margin: EdgeInsets.fromLTRB(30, 30, 100, 0),
                    child: TextButton(
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const ClientCalendar())
                          );
                        },
                        child: ClientTextBtn(
                          imgPath: "calendaricon.png",
                          title: "이달의 후원달력",)
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '이번 달 후원 포인트',
                          style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 15,
                              color: Colors.black),
                        ),
                        Image(
                            image: AssetImage("assets/images/coins.png"),
                          width: 15,
                          height: 15,
                        )
                      ],
                    ),
                  ),

                  LinearPercentIndicator(
                    padding: EdgeInsets.fromLTRB(40, 0, 30, 0),
                    width: MediaQuery.of(context).size.width - 10,
                    animation: true,
                    animationDuration: 100,
                    lineHeight: 20.0,
                    percent: percent_point, /////////////////////////////////////// 파베에서 가져올 데이터
                    center: Text(point),
                    progressColor: MyColor.DARK_YELLOW,
                    barRadius: Radius.circular(10),
                    backgroundColor: MyColor.LIGHT_GRAY,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(40, 2, 40, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "30,000P",
                      style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 10,
                          color: Colors.black),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(40, 15, 40, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '이번 달 후원 횟수',
                          style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 15,
                              color: Colors.black),
                        ),
                        Image(
                          image: AssetImage("assets/images/check.png"),
                          width: 15,
                          height: 15,
                        )
                      ],
                    ),
                  ),

                  LinearPercentIndicator(
                    padding: EdgeInsets.fromLTRB(40, 0, 30, 0),
                    width: MediaQuery.of(context).size.width - 10,
                    animation: true,
                    animationDuration: 100,
                    lineHeight: 20.0,
                    percent: percent_number, /////////////////////////////////////////////////
                    center: Text(number),
                    progressColor: MyColor.GOLD_YELLOW,
                    barRadius: Radius.circular(10),
                    backgroundColor: MyColor.LIGHT_GRAY,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(40, 2, 40, 10),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "10회",
                      style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 10,
                          color: Colors.black),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  TextButton(
                      onPressed: () async {
                        // await getImage(ImageSource.camera);
                        // if (_image == null) return;
                        //
                        // List<int> imageByte = await _image!.readAsBytes();
                        // String encodedImage = base64Encode(imageByte);
                        // print(encodedImage);
                        //
                        // final dio = Dio();
                        // final result = await dio.post(
                        //   "http://43.200.163.101:51854/",
                        //   data: {
                        //     'img': encodedImage,
                        //   },
                        // );
                        //
                        // print(result);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const ClientTempReceipt())
                        );
                      },
                      child: ClientYellowBtn(
                        imgPath: "receipt.png",
                        title: "영수증 인증하기",
                      )
                  ),

                  TextButton(
                      onPressed: () {},
                      child: ClientYellowBtn(
                        imgPath: "map.png",
                        title: "가맹점 확인하기",
                      )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget sliderWidget() {
    return CarouselSlider(
        items: List<List>.from(result).map(
        (imgInfo) {
            return Builder(
                builder: (context) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: Image.network(imgInfo[0]).image,
                          fit: BoxFit.cover
                        )
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 30, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text(
                                    imgInfo[1],
                                    style: TextStyle(
                                        fontFamily: "Pretendard",
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text(
                                    imgInfo[2],
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 15,
                                      color: Colors.white,),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(imgInfo[3]));
                                    },
                                    child: Container(
                                        width: 70,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '더보기',
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),],
                                            )
                                        )
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  );
                }
            );
          }
        ).toList(),
        options: CarouselOptions(
          height: 200,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }
        )
    );
  }

  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: result.asMap().entries.map((e) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(e.key),
            child: Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == e.key ? MyColor.GOLD_YELLOW : MyColor.DARK_YELLOW
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}