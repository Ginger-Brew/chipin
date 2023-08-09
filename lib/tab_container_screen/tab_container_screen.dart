import 'package:chipin/colors.dart';
import 'package:chipin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base_appbar.dart';
import '../core/utils/size_utils.dart';
import '../menu1/menu1.dart';
import '../menu2/menu2.dart';
import '../menu3/menu3.dart';

class TabContainerScreen extends StatefulWidget {
  const TabContainerScreen({Key? key})
      : super(
          key: key,
        );
  // final Set<TabContainerScreenState> _saved = new Set<TabContainerScreenState>();
  @override
  TabContainerScreenState createState() => TabContainerScreenState();
}

class TabContainerScreenState extends State<TabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  // final bool alreadySaved = _saved.contains(pair);
  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyColor.BACKGROUND,
        appBar: BaseAppBar(title: "가게정보"),

        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/images/ohyang_restaurant.png"),
                  width: 390,
                  height: 176,
                  fit: BoxFit.fill,
                ),

                Padding(
                  padding: getPadding(
                    left: 26,
                    top: 27,
                    right: 22,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(
                              left: 1,
                            ),
                            child: Text(
                              "오양칼국수",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                                style: const TextStyle(fontSize:24, fontFamily: "Mainfonts",color: Colors.black)
                            ),
                          ),
                          Padding(
                            padding: getPadding(
                              top: 2,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                  size: 19,
                                ),

                                Padding(
                                  padding: getPadding(
                                    left: 4,
                                  ),
                                  child: Text(
                                    "충남 보령시 보령남로 125-7",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    // style: CustomTextStyles
                                    //     .bodyLargePrimaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      FloatingActionButton(
                        onPressed: (){},
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite,color : Colors.red),)

                    ],
                  ),
                ),
                Container(
                  margin: getMargin(
                    left: 21,
                    top: 24,
                    right: 21,
                  ),
                  padding: getPadding(
                    all: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color:  Color(0XFFB3BFCB).withOpacity(0.46)
                    color: Color(0xFFB3BFCB).withOpacity(0.46)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: getPadding(
                          left: 1,
                          top: 1,
                          bottom: 3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                Padding(
                                  padding: getPadding(
                                    left: 7,
                                    top: 3,
                                    bottom: 1,
                                  ),
                                  child: Text(
                                    "십시일반 포인트 17950원",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    // style: theme.textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: getPadding(
                                left: 3,
                                top: 11,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      left: 9,
                                      top: 1,
                                    ),
                                    child: Text(
                                      "매일 09:00 ~ 19:00",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      // style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: getVerticalSize(
                    59,
                  ),
                  width: double.maxFinite,
                  margin: getMargin(
                    top: 24,
                  ),
                  child: TabBar(
                    controller: tabviewController,
                    labelColor: Color(0xFF292D32),
                    labelStyle: TextStyle(),
                    unselectedLabelColor: Color(0xFFB3BFCB),
                    unselectedLabelStyle: TextStyle(),
                    indicatorColor: Color(0xFFFFC95F),
                    tabs: [
                      Tab(
                        child: Text(
                          "식사 메뉴",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Tab(
                        child: Text(
                          "추가 메뉴",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Tab(
                        child: Text(
                          "음료수",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(
                    309,
                  ),
                  child: TabBarView(
                    controller: tabviewController,
                    children: [
                      menu1(),
                      menu2(),
                      menu3(),
                    ],
                  ),
                ),

              ],
            ),

          ),

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed:(){},
          label: Text("예약하기",
            style: TextStyle(fontFamily: "Mainfonts",color: Colors.white),
          ),
          icon: Icon(Icons.check),
          backgroundColor: MyColor.DARK_YELLOW,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // 오른쪽 아래에 배치

      ),

    );
  }
}
