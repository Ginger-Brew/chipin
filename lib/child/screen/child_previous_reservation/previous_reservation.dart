import 'package:chipin/child/screen/child_appbar/ChildAppBar.dart';
import 'package:chipin/child/screen/child_previous_reservation/write_thank_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../base_appbar.dart';
import '../child_appbar/ChildDrawerMenu.dart';

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
      appBar: const ChildAppBar(title: "지난 식사 내역"),
      endDrawer: const ChildDrawerMenu(),
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
              final mealDateTimestamp =
                  reservation['reservationDate'] as Timestamp;
              final mealDate = mealDateTimestamp.toDate();

              final restaurantDocFuture =
                  _firestore.collection('Restaurant').doc(restaurantId).get();
              return FutureBuilder<DocumentSnapshot>(
                  future: restaurantDocFuture,
                  builder: (context, restaurantDocSnapshot) {
                    if (restaurantDocSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(), // 데이터를 기다리는 동안 로딩 표시
                      );
                    }
                    if (restaurantDocSnapshot.hasError) {
                      return Text('Error: ${restaurantDocSnapshot.error}');
                    }
                    final restaurantData = restaurantDocSnapshot.data!.data()
                        as Map<String, dynamic>?;
                    final restaurantName = restaurantData?['name'] ?? '';
                    final restaurantAddress = restaurantData?['address1'] ?? '';
                    final restaurantBanner = restaurantData?['banner'] ?? '';
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Row(
                        children: [
                          Container(
                            width: 80,
                            // Set the desired width for the restaurant image
                            height: 80,
                            // Set the desired height for the restaurant image
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(restaurantBanner),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(
                                  10), // Add border radius for rounded corners
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Add some spacing between image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$restaurantName',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    DateFormat('yyyy년 MM월 dd일 HH:mm').format(mealDate)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: reservation['isReviewed'] ==
                              true // isReviewed가 true인 경우
                          ? const ElevatedButton(
                              onPressed: null,
                              child: Text('편지 작성 완료',
                                  style: TextStyle(color: Colors.white)),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                // 버튼 클릭 시 작성 페이지로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WriteThankYouNotePage(
                                      restaurantEmail: restaurantId,
                                      mealDate: mealDateTimestamp,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('감사편지 작성'),
                            ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
