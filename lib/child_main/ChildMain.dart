import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'bottom_sheet.dart';

class ChildMain extends StatefulWidget {
  @override
  _ChildMainState createState() => _ChildMainState();
}

class _ChildMainState extends State<ChildMain> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;
  bool bottomSheetOpened = false;
  void setBottomSheetOpend(bool opend) {
    setState(() {
      bottomSheetOpened = opend;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Column(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Expanded(
          //         child: userLocation == null
          //             ? const Center(
          //           child: Text("Loading..."),
          //         )
          //             : GoogleMap(
          //           markers: Set.from(_markers),
          //           mapType: MapType.normal,
          //           initialCameraPosition: userLocation!,
          //           myLocationEnabled: true,
          //           onMapCreated: (GoogleMapController controller) {
          //             _controller.complete(controller);
          //           },
          //         )),
          //   ],
          // ),
          MapBottomSheet(),
        ],
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}
