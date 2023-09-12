//https://cholol.tistory.com/574

import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  late String image;
  late String title;
  late String location;
  late String opentime;
  late String closetime;
  late String phonenum;
  late String registrationnum;

  Restaurant({required this.image, required this.title, required this.location, required this.opentime,
      required this.closetime, required this.phonenum, required this.registrationnum});

  Restaurant.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    image = data['banner'];
    title = data['name'];
    location = data['address1'] + " " + data['address2'];
    opentime = data['openH'] + " : " + data['openM'];
    closetime = data['closeH'] + " : " + data['closeM'];
    phonenum = data['phone'];
    registrationnum = data['businessnumber'];
  }


}