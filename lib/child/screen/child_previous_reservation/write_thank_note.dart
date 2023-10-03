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
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;
    final amailVerified = user.emailVerified;
    final uid = user.uid;
  }
  return user;
}
class _WriteThankYouNotePageState extends State<WriteThankYouNotePage> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  void _saveThankYouNote() async {
    // final user = _auth.currentUser;
    User? currentUser = getUser();

    if (currentUser == null) {
      // 사용자가 로그인하지 않았다면 처리
      return;
    }

    final String noteText = _noteController.text.trim();
    if (noteText.isNotEmpty) {
      final reviewCollection = _firestore.collection('Review');
      final randomDocName = reviewCollection.doc().id;
      await reviewCollection.doc(randomDocName).set({
        'childId' : currentUser.email,
        'childNickname' : currentUser.displayName,
        'content' : noteText,
        'restaurantId' :widget.restaurantEmail,
        'timestamp' : widget.mealDate
      });

      // 감사편지 작성 완료 후 이전 화면으로 돌아감
      Navigator.pop(context);
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