import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WriteThankYouNotePage extends StatefulWidget {
  final String restaurantEmail;
  final Timestamp mealDate;
  const WriteThankYouNotePage({super.key, required this.restaurantEmail, required this.mealDate});
  @override
  _WriteThankYouNotePageState
  createState() => _WriteThankYouNotePageState();
}
User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final email = user.email;
    final name = user.displayName;

    final photoUrl = user.photoURL;
    final amailVerified = user.emailVerified;
    final uid = user.uid;
  }
  return user;
}
Future<String?> getUserName (String? userEmail) async {
  try {
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = await userCollection.doc(userEmail).get();
    final userinfoCollection = userDoc.reference.collection('userinfo');
    final userinfoDoc = await userinfoCollection.doc('userinfo').get();

    if (userinfoDoc.exists) {
        print("좀되라ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ");
        print(userinfoDoc['name']);
        return userinfoDoc['name'] as String?;
    }

  } catch (e) {
    print('Error getting user name: $e');
  }

  return null; // 오류 발생 시 또는 데이터를 찾지 못한 경우 null 반환
}
class _WriteThankYouNotePageState extends State<WriteThankYouNotePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  void _saveThankYouNote() async {
    // final user = _auth.currentUser;
    User? currentUser = getUser();
    final String? userEmail = currentUser?.email;

    if (currentUser == null) {
      // 사용자가 로그인하지 않았다면 처리
      return;
    }
    final userName = await getUserName(userEmail);
    final String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      final reviewCollection = _firestore.collection('Review');
      final randomDocName = reviewCollection.doc().id;
      await reviewCollection.doc(randomDocName).set({
        'childId' :userEmail,
        'childNickname' : userName,
        'content' : noteText,
        'restaurantId' :widget.restaurantEmail,
        'timestamp' : widget.mealDate
      });
      saveReviewStatus(userEmail!, widget.restaurantEmail, widget.mealDate);
      // 감사편지 작성 완료 후 이전 화면으로 돌아감
      Navigator.pop(context);
    }
  }
  Future<void> saveReviewStatus(String userId, String restaurantId, Timestamp mealDate) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Child 컬렉션에서 해당 userId 문서 가져오기
      final childDocRef = firestore.collection("Child").doc(userId);
      final childDocSnapshot = await childDocRef.get();

      if (childDocSnapshot.exists) {
        // ReservationInfo 컬렉션에서 해당 restaurantId와 mealDate와 일치하는 예약 정보 가져오기
        final reservationQuery = await firestore
            .collection("Child")
            .doc(userId)
            .collection("ReservationInfo")
            .where("restaurantId", isEqualTo: restaurantId)
            .where("reservationDate", isEqualTo: mealDate)
            .get();

        // 가져온 예약 정보의 isReviewed 필드를 true로 설정
        for (final reservationDoc in reservationQuery.docs) {
          await reservationDoc.reference.update({"isReviewed": true});
        }

        // 성공적으로 업데이트되었을 때, 해당 작업을 로그에 기록하거나 추가 로직을 수행할 수 있습니다.
        print("Review status updated successfully.");
      } else {
        // userId에 해당하는 Child 문서가 존재하지 않을 때 처리
        print("Child document not found for userId: $userId");
      }
    } catch (e) {
      // 오류 처리
      print("Error updating review status: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('감사편지 작성'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '감사편지 내용을 입력하세요...',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveThankYouNote,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}