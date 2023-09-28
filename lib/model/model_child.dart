import 'dart:html';
import 'package:flutter/material.dart';

class Child extends ChangeNotifier {
  int? cancellationCount;
  DateTime? cancellationDate;
  DateTime? cardAuthenticatedDate;
  bool? isCardAuthenticated;
  Geolocation? currentLocation;
  List? favoriteRestaurant;
  bool? idInReservation;
  int? mealCount;
  int? penaltyCount;
  int? reservationCount;


  Child(
      {this.cancellationCount = 0,
      this.cancellationDate = null,
      this.cardAuthenticatedDate = null,
      this.isCardAuthenticated = false,
      this.currentLocation = null,
      this.favoriteRestaurant = const [],
      this.idInReservation = false,
      this.mealCount = 0,
      this.penaltyCount = 0,
      this.reservationCount = 0});

  /// factory : Child 싱글톤 구현
  factory Child.fromJson(Map<dynamic, dynamic> json) {
    return Child(
      cancellationCount: json['cancellationCount'],
      cancellationDate: json['cancellationDate'],
      cardAuthenticatedDate: json['cardAuthenticatedDate'],
      isCardAuthenticated: json['isCardAuthenticated'],
      currentLocation: json['currentLocation'],
      favoriteRestaurant: json['favoriteRestaurant'],
      idInReservation: json['idInReservation'],
      mealCount: json['mealCount'],
      penaltyCount: json['penaltyCount'],
      reservationCount: json['reservationCount']
    );
  }

  toJson() {
    return {
      'cancellationCount' : cancellationCount,
      'cancellationDate' : cancellationDate,
      'cardAuthenticatedDate' : cardAuthenticatedDate,
      'isCardAuthenticated' : isCardAuthenticated,
      'currentLocation' : currentLocation,
      'favoriteRestaurant' : favoriteRestaurant,
      'idInReservation' : idInReservation,
      'mealCount' : mealCount,
      'penaltyCount' : penaltyCount,
      'reservationCount' : reservationCount
    };
  }
}