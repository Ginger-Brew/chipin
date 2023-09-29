import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  createState() => _CustomGoogleMapState();
}

List<Map<String, dynamic>> _markers = [];

final markers = <Marker>{};

/// Google Map in the background
class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late double longitude;
  late double latitude;

  late LatLng schoolLatlng;
  late CameraPosition initialPosition;

  Future<bool> getLocationAndMark() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    this.longitude = position.longitude;
    this.latitude = position.latitude;

    FirebaseFirestore.instance
        .collection('Restaurant')
        .snapshots()
        .listen((data) {
      for (var element in data.docs) {
        _markers.add({
          "name" : element['name'],
          "latitude": double.parse(element['latitude']),
          "longitude": double.parse(element['longitude']),
        });
      }
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getLocationAndMark(), builder: (context, snapshot) {
      if(!(snapshot.hasData)) {
        return CircularProgressIndicator();
      }
      else if(snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {

        /// 현재 위치
        schoolLatlng = LatLng(this.latitude, this.longitude);
        initialPosition = CameraPosition(
          //지도를 바라보는 카메라 위치
          target: schoolLatlng, //카메라 위치(위도, 경도)
          zoom: 15, //확대 정도
        );

        /// 마커 설정
        markers.addAll(
          _markers.map(
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

        return Container(
          color: Colors.blue[50],
          child: GoogleMap(
            //구글 맵 사용
              mapType: MapType.normal, //지도 유형 설정
              initialCameraPosition: initialPosition, //지도 초기 위치 설정
              markers: markers
          ),
        );
      }
    },);
  }
}