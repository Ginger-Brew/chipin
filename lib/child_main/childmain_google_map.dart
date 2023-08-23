import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

final _foodies = [
  {
    "name": "오양칼국수",
    "latitude": 37.4999613,
    "longitude": 127.0281036,
  },
  {
    "name": "권영철 콩짬뽕",
    "latitude": 37.5039059,
    "longitude": 127.0263972,
  },
  {
    "name": "파이브가이즈",
    "latitude": 37.5012238,
    "longitude": 127.0256401,
  },
];

final _markers = <Marker>{};

/// Google Map in the background
class _CustomGoogleMapState extends State<CustomGoogleMap> {

  @override
  void initState() {
    _markers.addAll(
      _foodies.map(
            (e) => Marker(
          markerId: MarkerId(e['name'] as String),
          infoWindow: InfoWindow(title: e['name'] as String),
          position: LatLng(
            e['latitude'] as double,
            e['longitude'] as double,
          ),
        ),
      ),
    );
    super.initState();
  }

  static final LatLng schoolLatlng = LatLng(
    //위도와 경도 값 지정
    37.4999613,
    127.0281036
  );

  static final CameraPosition initialPosition = CameraPosition(
    //지도를 바라보는 카메라 위치
    target: schoolLatlng, //카메라 위치(위도, 경도)
    zoom: 15, //확대 정도
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      child: GoogleMap(
        //구글 맵 사용
        mapType: MapType.normal, //지도 유형 설정
        initialCameraPosition: initialPosition, //지도 초기 위치 설정
        markers: _markers
      ),
    );
  }
}