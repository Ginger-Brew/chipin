import 'package:flutter/material.dart';

import '../core/utils/size_utils.dart';

// ignore_for_file: must_be_immutable
class MenuPage extends StatefulWidget {
  final List<Map<String, dynamic>> menuDataList; // menuDataList 추가
  const MenuPage({
    Key? key,
    required this.menuDataList
  })
      : super(
    key: key,
  );

  @override
  MenuPageState createState() => MenuPageState(menuDataList: menuDataList);
}
class MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin<MenuPage> {
  late final List<Map<String, dynamic>> _menuDataList;

  MenuPageState({
    required List<Map<String, dynamic>> menuDataList,
  }) {
    _menuDataList = menuDataList;
  }
  void logListConstents() {
    for (var item in _menuDataList) {
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbb');
      print(item);
    }
  }

  List<Widget> _buildMenuItems() {
    print('sal;kdfjlsdajlnfksdj;flinjd;dklfsjf;cnsl aljfs제발좀 log');
    List<Widget> menuWidgets = [];
    for (var item in _menuDataList) {
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbb');
      print(item);
    }
    for (var item in _menuDataList) {
      final menuName = item['name'] as String;
      final menuPrice = item['price'] as int;

      // 'name'과 'price'만 출력하는 위젯 생성
      final menuItemWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            menuName,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              // 원하는 스타일을 설정하세요.
            ),
          ),
          Text(
            '$menuPrice원',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              // 원하는 스타일을 설정하세요.
            ),
          ),
          Divider(
            height: getVerticalSize(1),
            thickness: getVerticalSize(1),
            // 필요에 따라 스타일 설정
          ),
        ],
      );
// 아래 두 줄은 _menuDataList의 값을 확인하는 로그입니다.
      print('Menu Name: $menuName');
      print('Menu Price: $menuPrice');
      menuWidgets.add(menuItemWidget);
    }

    return menuWidgets;
  }

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
                            Column(
                              children: _buildMenuItems(),
                            )
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

// class MenuPageState extends State<MenuPage>
//     with AutomaticKeepAliveClientMixin<MenuPage> {
//   late final List<Map<String,dynamic>> _menuDataList;
//   MenuPageState({
//     required List<Map<String,dynamic>> menuDataList,
// }){
//     _menuDataList = menuDataList;
//   }
//   @override
//   bool get wantKeepAlive => true;
//   @override
//   Widget build(BuildContext context) {
//     mediaQueryData = MediaQuery.of(context);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SizedBox(
//           width: mediaQueryData.size.width,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: getPadding(
//                     top: 26,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: getVerticalSize(
//                           369,
//                         ),
//                         width: double.maxFinite,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Align(
//                               alignment: Alignment.topCenter,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: getPadding(
//
//                                       left: 33,
//                                       right: 15,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               menuName,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.left,
//                                               // style: theme.textTheme.titleLarge,
//                                             ),
//                                             Padding(
//                                               padding: getPadding(
//                                                 top: 1,
//                                               ),
//                                               child: Text(
//                                                 "$menuPrice원",
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.left,
//                                                 // style:
//                                                 // theme.textTheme.bodyLarge,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                     ),
//                                     child: Divider(
//                                       height: getVerticalSize(
//                                         1,
//                                       ),
//                                       thickness: getVerticalSize(
//                                         1,
//                                       ),
//                                       // color: theme.colorScheme.onError,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                       left: 33,
//                                       right: 15,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "키.칼 (보리밥)",
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.left,
//                                               // style: theme.textTheme.titleLarge,
//                                             ),
//                                             Padding(
//                                               padding: getPadding(
//                                                 top: 1,
//                                               ),
//                                               child: Text(
//                                                 "9000원",
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.left,
//                                                 // style:
//                                                 // theme.textTheme.bodyLarge,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                     ),
//                                     child: Divider(
//                                       height: getVerticalSize(
//                                         1,
//                                       ),
//                                       thickness: getVerticalSize(
//                                         1,
//                                       ),
//                                       // color: theme.colorScheme.onError,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                       left: 33,
//                                       right: 15,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "오.키칼 (보리밥)",
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.left,
//                                               // style: theme.textTheme.titleLarge,
//                                             ),
//                                             Padding(
//                                               padding: getPadding(
//                                                 top: 1,
//                                               ),
//                                               child: Text(
//                                                 "10000원",
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.left,
//                                                 // style:
//                                                 // theme.textTheme.bodyLarge,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                     ),
//                                     child: Divider(
//                                       height: getVerticalSize(
//                                         1,
//                                       ),
//                                       thickness: getVerticalSize(
//                                         1,
//                                       ),
//                                       // color: theme.colorScheme.onError,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                       left: 33,
//                                       right: 15,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "오.칼 (보리밥)",
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.left,
//                                               // style: theme.textTheme.titleLarge,
//                                             ),
//                                             Padding(
//                                               padding: getPadding(
//                                                 top: 1,
//                                               ),
//                                               child: Text(
//                                                 "9000원",
//                                                 overflow: TextOverflow.ellipsis,
//                                                 textAlign: TextAlign.left,
//                                                 // style:
//                                                 // theme.textTheme.bodyLarge,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: getPadding(
//                                       top: 15,
//                                     ),
//                                     child: Divider(
//                                       height: getVerticalSize(
//                                         1,
//                                       ),
//                                       thickness: getVerticalSize(
//                                         1,
//                                       ),
//                                       // color: theme.colorScheme.onError,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }