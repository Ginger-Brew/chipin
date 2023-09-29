import 'package:chipin/child_previous_reservation/write_thank_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_appbar.dart';

class PreviousReservation extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: "지난 식사 내역"),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('meal_history').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final mealHistoryDocs = snapshot.data!.docs;

          return ListView.builder(
              itemCount: mealHistoryDocs.length,
              itemBuilder: (context, index){
                final meal = mealHistoryDocs[index];
                final restaurantName = meal['restaurantName'] ?? '';
                final mealDate = meal['mealDate'] ?? '';

                return ListTile(
                  title: Text ('$restaurantName, $mealDate'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WriteThankYouNotePage()
                      )
                      );
                    },
                    child: Text('감사편지 작성'),
                  ),
                );
              });
          },
      ),

    );
  }
}