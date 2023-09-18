import 'package:chipin/colors.dart';
import 'package:chipin/main.dart';
import 'package:flutter/material.dart';

import 'package:chipin/base_appbar.dart';
import '../child_custom_price/custom_price.dart';
import '../core/utils/size_utils.dart';
import '../menu_meals/meals.dart';
import '../menu_thanks/thanks.dart';

class TabContainerScreen extends StatefulWidget {
  final String restaurantName;
  final String restaurantAddress;
  final String openingHours;
  final String bannerImageUrl;

  const TabContainerScreen({
    Key? key,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.openingHours,
    required this.bannerImageUrl,
  }) : super(key: key);
  // final Set<TabContainerScreenState> _saved = new Set<TabContainerScreenState>();
  @override
  TabContainerScreenState createState() => TabContainerScreenState(restaurantName: restaurantName, restaurantAddress: restaurantAddress, openingHours: openingHours, bannerImageUrl: bannerImageUrl);
}

class TabContainerScreenState extends State<TabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  // final bool alreadySaved = _saved.contains(pair);
  bool _isFavorite = false; // 즐겨찾기 상태
  final List<String> _favoriteItems = []; // 즐겨찾기 리스트

  late String _restaurantName = "";
  late String _restaurantAddress = "";
  late String _openingHours = "";
  late String _bannerImageUrl = "";
  // 생성자를 추가하여 인자로 변수들을 받아옵니다.
  TabContainerScreenState({
    required String restaurantName,
    required String restaurantAddress,
    required String openingHours,
    required String bannerImageUrl,
  }) {
    _restaurantName = restaurantName;
    _restaurantAddress = restaurantAddress;
    _openingHours = openingHours;
    _bannerImageUrl = bannerImageUrl;
    // 나머지 변수들을 이용하여 원하는 작업 수행
  }
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
        appBar: const BaseAppBar(title: "가게정보"),

        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(_bannerImageUrl),
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
                                _restaurantName,
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
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.black,
                                  size: 19,
                                ),

                                Padding(
                                  padding: getPadding(
                                    left: 4,
                                  ),
                                  child: Text(
                                    _restaurantAddress,
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
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;

                          if (_isFavorite) {
                            _favoriteItems.add(_restaurantName); // 즐겨찾기 리스트에 아이템 추가
                          } else {
                            _favoriteItems.remove(_restaurantName); // 즐겨찾기 리스트에서 아이템 제거
                          }
                        });

                        // TODO: 즐겨찾기 리스트에 추가 또는 제거하는 동작 추가
                      },
                      backgroundColor: Colors.white,
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.black12,
                      ),
                    )
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
                    color: const Color(0xFFB3BFCB).withOpacity(0.46)
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
                                const Icon(
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
                                  child: const Text(
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
                                  const Icon(
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
                                      _openingHours,
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
                    labelColor: const Color(0xFF292D32),
                    labelStyle: const TextStyle(),
                    unselectedLabelColor: const Color(0xFFB3BFCB),
                    unselectedLabelStyle: const TextStyle(),
                    indicatorColor: const Color(0xFFFFC95F),
                    tabs: const [
                      Tab(
                        child: Text(
                          "메뉴  보기",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Tab(
                        child: Text(
                          "감사 편지 읽기",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Tab(
                      //   child: Text(
                      //     "음료수",
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(
                    309,
                  ),
                  child: TabBarView(
                    controller: tabviewController,
                    children: const [
                      menu(),
                      thanks(),
                      // menu3(),
                    ],
                  ),
                ),

              ],
            ),

          ),

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed:(){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomPricePage()));
          },
          label: const Text("예약하기",
            style: TextStyle(fontFamily: "Mainfonts",color: Colors.white),
          ),
          icon: const Icon(Icons.check),
          backgroundColor: MyColor.DARK_YELLOW,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // 오른쪽 아래에 배치

      ),

    );
  }
}
