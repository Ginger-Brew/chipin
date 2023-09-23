import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

final _foodies = [];

final _markers = <Marker>{};

/// Google Map in the background
class _CustomGoogleMapState extends State<CustomGoogleMap> {

  @override
  void initState() {
    FirebaseFirestore.instance
      .collection('Restaurant')
      .snapshots()
      .listen((data) {
        for (var element in data.docs) {
          _foodies.add({
            "name" : element['name'],
            "latitude": element['latitude'],
            "longitude": element['longitude'],
          });
        }
    });

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