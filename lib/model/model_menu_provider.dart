import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model_menu.dart';

class MenuProvider with ChangeNotifier {
  late CollectionReference menusReference;
  List<Menu> menus = [];

  MenuProvider({reference}) {
    menusReference = reference ?? FirebaseFirestore.instance.collection('menus');
  }

  Future<void> fetchMenus() async {
    menus = await menusReference.get().then( (QuerySnapshot results) {
      return results.docs.map( (DocumentSnapshot document) {
        return Menu.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
  }
}