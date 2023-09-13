import 'package:flutter/material.dart';

import '../core/utils/size_utils.dart';

// ignore_for_file: must_be_immutable
class menu extends StatefulWidget {
  const menu({Key? key})
      : super(
          key: key,
        );

  @override
  menuState createState() => menuState();
}

class menuState extends State<menu>
    with AutomaticKeepAliveClientMixin<menu> {
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
                                            Text(
                                              "오.칼 (보리밥)",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: Text(
                                                "9000원",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
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
                                            Text(
                                              "키.칼 (보리밥)",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: Text(
                                                "9000원",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
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
                                            Text(
                                              "오.키칼 (보리밥)",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: Text(
                                                "10000원",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
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
                                            Text(
                                              "오.칼 (보리밥)",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              // style: theme.textTheme.titleLarge,
                                            ),
                                            Padding(
                                              padding: getPadding(
                                                top: 1,
                                              ),
                                              child: Text(
                                                "9000원",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                // style:
                                                // theme.textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
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
