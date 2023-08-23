import 'package:flutter/material.dart';
import '../base_appbar_transparent.dart';
import 'childmain_google_map.dart';
import 'childmain_scrollview.dart';
import 'childmain_search.dart';


class ChildMain extends StatefulWidget {
  const ChildMain({super.key});

  @override
  State<ChildMain> createState() => _ChildMainState();
}


class _ChildMainState extends State<ChildMain> {

  final GlobalKey _containerkey = GlobalKey();

  Size? size;
  Size? _getSize() {
    if (_containerkey.currentContext != null) {
      final RenderBox renderBox =
      _containerkey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        size = _getSize();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BaseAppBarTransparent(),
          CustomGoogleMap(),
          ChildMainSearch(),
          DraggableScrollableSheet(
            /// 수정 필요
            // 결과 높이를 구해서 maxChildSize로 설정해야함.
            initialChildSize: 0.30,
            minChildSize: 0.15,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                key: _containerkey,
                controller: scrollController,
                child: CustomScrollViewContent(),
              );
            },
          ),
        ],
      ),
    );
  }
}

