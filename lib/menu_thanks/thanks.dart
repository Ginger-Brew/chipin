import 'package:flutter/material.dart';

import '../core/utils/size_utils.dart';

// ignore_for_file: must_be_immutable
class thanks extends StatefulWidget {
  const thanks({Key? key})
      : super(
    key: key,
  );

  @override
  thanksState createState() => thanksState();
}

class thanksState extends State<thanks>
    with AutomaticKeepAliveClientMixin<thanks> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(
                    top: 26,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getVerticalSize(
                          369,
                        ),
                        width: double.maxFinite,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: getPadding(

                                      left: 33,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "너무 맛있는 한 끼 였습니다. \n 감사합니다.",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: const Text(
                                                "ID1",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // 신고 버튼을 클릭할 때 수행할 동작을 여기에 추가
                                          },
                                          child: const Text(
                                            "신고하기",
                                            style: TextStyle(
                                              fontFamily: "Mainfonts",
                                              color: Colors.grey, // 회색으로 설정
                                              fontSize: 12, // 원하는 글씨 크기 설정
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 15,
                                    ),
                                    child: Divider(
                                      height: getVerticalSize(
                                        1,
                                      ),
                                      thickness: getVerticalSize(
                                        1,
                                      ),
                                      // color: theme.colorScheme.onError,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 15,
                                      left: 33,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "여기 사장님 최고 ㅜㅜ 너무 맛있어요",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: const Text(
                                                "ID2",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),

                                          ],

                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // 신고 버튼을 클릭할 때 수행할 동작을 여기에 추가
                                          },
                                          child: const Text(
                                            "신고하기",
                                            style: TextStyle(
                                              fontFamily: "Mainfonts",
                                              color: Colors.grey, // 회색으로 설정
                                              fontSize: 12, // 원하는 글씨 크기 설정
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 15,
                                    ),
                                    child: Divider(
                                      height: getVerticalSize(
                                        1,
                                      ),
                                      thickness: getVerticalSize(
                                        1,
                                      ),
                                      // color: theme.colorScheme.onError,
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 15,
                                      left: 33,
                                      right: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "감사해요. 너무 맛있네요",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: const Text(
                                                "ID3",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),

                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // 신고 버튼을 클릭할 때 수행할 동작을 여기에 추가
                                          },
                                          child: const Text(
                                            "신고하기",
                                            style: TextStyle(
                                              fontFamily: "Mainfonts",
                                              color: Colors.grey, // 회색으로 설정
                                              fontSize: 12, // 원하는 글씨 크기 설정
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 15,
                                    ),
                                    child: Divider(
                                      height: getVerticalSize(
                                        1,
                                      ),
                                      thickness: getVerticalSize(
                                        1,
                                      ),
                                      // color: theme.colorScheme.onError,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
