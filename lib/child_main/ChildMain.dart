import 'package:flutter/material.dart';
import '../base_appbar_transparent.dart';
import 'childmain_google_map.dart';
import 'childmain_scrollview.dart';
import 'childmain_search.dart';

class ChildMain extends StatelessWidget {
  const ChildMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BaseAppBarTransparent(),
          CustomGoogleMap(),
          ChildMainSearch(),
          DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.15,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
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

