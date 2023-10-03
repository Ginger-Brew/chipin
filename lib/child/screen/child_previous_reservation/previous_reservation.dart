import 'package:chipin/child/screen/child_previous_reservation/write_thank_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base_appbar.dart';

User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;

    final emailVerified = user.emailVerified;
    final uid = user.uid;
  }
  return user;
}
class PreviousReservation extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentChild = getUser();
  PreviousReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: "지난 식사 내역"),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Child')
            .doc(currentChild?.email) // 현재 사용자의 UID를 사용하여 해당 문서에 접근
            .collection('ReservationInfo')
            .where('isUsed', isEqualTo: true) // isUsed가 true인 예약 정보만 필터링
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final reservationDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservationDocs.length,
            itemBuilder: (context, index) {
              final reservation = reservationDocs[index];
              final restaurantId = reservation['restaurantId'] ?? '';
              final mealDateTimestamp = reservation['reservationDate'] as Timestamp;
              final mealDate = mealDateTimestamp.toDate();

// DateTime을 "YYYYMMDD HHMMSS" 포맷으로 포맷팅
              final formattedMealDate = DateFormat('yyyyMMdd HH:mm').format(mealDate);
              final restaurantDocFuture =
              _firestore.collection('Restaurant').doc(restaurantId).get();
              return FutureBuilder<DocumentSnapshot>(
                future: restaurantDocFuture,
                builder: (context, restaurantDocSnapshot) {
                  if (restaurantDocSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (restaurantDocSnapshot.hasError) {
                    return  Text('Error: ${restaurantDocSnapshot.error}');
                  }
                  final restaurantData =
                  restaurantDocSnapshot.data!.data() as Map<String, dynamic>?;
                  final restaurantName = restaurantData?['name'] ?? '';
                  final restaurantAddress = restaurantData?['address1'] ?? '';
                  final restaurantBanner = restaurantData?['banner'] ?? '';
                  return ListTile(
                    title: Text('$restaurantName,${DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(mealDate)}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteThankYouNotePage(),
                          ),
                        );
                      },
                      child: Text('감사편지 작성'),
                    ),
                  );
                }
              );

            },
          );
        },
      ),
    );
  }
}
