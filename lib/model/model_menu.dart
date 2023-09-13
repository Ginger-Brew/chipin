import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  late String explain;
  late String name;
  late String price;

  Menu({required this.explain, required this.name, required this.price});

  Menu.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    explain = data['explain'];
    name = data['name'];
    price = data['price'];
  }
}