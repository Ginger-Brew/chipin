import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Child extends ChangeNotifier {
  int? cancellationCount;
  DateTime? cancellationDate;
  DateTime? cardAuthenticatedDate;
  bool? isCardAuthenticated;
  List? favoriteRestaurant;
  bool? idInReservation;
  int? mealCount;
  int? penaltyCount;
  int? reservationCount;

  static final Child _child = new Child._internal();

  /// factory : Child 싱글톤 구현
  factory Child() {
    return _child;
  }

  Child._internal() {
    //  초기화 코드
    this.cancellationCount = 0;
    this.cancellationDate = null;
    this.cardAuthenticatedDate = null;
    this.isCardAuthenticated = false;
    this.favoriteRestaurant = const [];
    this.idInReservation = false;
    this.mealCount = 0;
    this.penaltyCount = 0;
    this.reservationCount = 0;
  }

  plusCancellatthionCount() {
    this.cancellationCount = (this.cancellationCount! + 1);

    String? userid = FirebaseAuth.instance.currentUser!.email;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore
        .collection('Child')
        .doc(userid)
        .update({'cancellationCount': this.cancellationCount});
  }

  getIsCardAuthenticated() => this.isCardAuthenticated;

  toJson() {
    return {
      'cancellationCount' : cancellationCount,
      'cancellationDate' : cancellationDate,
      'cardAuthenticatedDate' : cardAuthenticatedDate,
      'isCardAuthenticated' : isCardAuthenticated,
      'favoriteRestaurant' : favoriteRestaurant,
      'idInReservation' : idInReservation,
      'mealCount' : mealCount,
      'penaltyCount' : penaltyCount,
      'reservationCount' : reservationCount
    };
  }
}