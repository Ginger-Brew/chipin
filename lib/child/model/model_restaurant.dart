//https://cholol.tistory.com/574

import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String? image;
  String? title;
  String? location;
  String? opentime;
  String? closetime;
  String? phonenum;
  String? registrationnum;
  String? id;

  Restaurant({this.image = "", this.title = "", this.location = "", this.opentime = "",
      this.closetime = "", this.phonenum = "", this.registrationnum = "", this.id = ""});

  void fromJson(String restaurantId, Map<dynamic, dynamic> json) {
    this.image = json['banner'];
    this.title = json['name'];
    this.location = json['address1'] + " " + json['address2'];
    this.opentime = json['openH'] + " : " + json['openM'];
    this.closetime = json['closeH'] + " : " + json['closeM'];
    this.phonenum = json['phone'];
    this.registrationnum = json['businessnumber'];
    this.id = restaurantId;
    //reports= json['reports'].map((report) => Report.fromJson(report)).toList();
  }

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

  Future<List<Restaurant>> getSearchRestaurantList(String searchContents) async {
    List<Restaurant> _restaurants = [];

    await FirebaseFirestore.instance.collection('Restaurant').get().then(
          (querySnapshot) {
        for (var restaurant in querySnapshot.docs) {
          Restaurant _restaurant = Restaurant();
          // querySnapshot.docs.data() => Map
          _restaurant.fromJson(restaurant.id, restaurant.data());
          if (_restaurant.title!.contains(searchContents)) {
            _restaurants.add(_restaurant);
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return _restaurants;
  }
}