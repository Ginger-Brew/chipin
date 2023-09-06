import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model_restaurant.dart';

class RestaurantProvider with ChangeNotifier {
  late CollectionReference restaurantsReference;
  List<Restaurant> restaurants = [];

  RestaurantProvider({reference}) {
    restaurantsReference = reference ?? FirebaseFirestore.instance.collection('Restaurant');
  }

  Future<void> fetchRestaurants() async {
    restaurants = await restaurantsReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Restaurant.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
  }
}