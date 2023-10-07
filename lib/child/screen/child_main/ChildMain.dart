import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'childmain_google_map.dart';
import 'childmain_scrollview.dart';
import 'childmain_search.dart';


class ChildMain extends StatefulWidget {
  const ChildMain({super.key});

  @override
  State<ChildMain> createState() => _ChildMainState();
}
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

class _ChildMainState extends State<ChildMain> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentChild = getUser();
  final GlobalKey _containerkey = GlobalKey();

  Future<void> checkAndUpdateReservationStatus() async {
    final currentDateTime = DateTime.now();

    final reservationQuery = await _firestore
        .collection('Child')
        .doc(currentChild?.email)
        .collection('ReservationInfo')
        .where('expirationDate', isGreaterThan: currentDateTime)
        .get();

    final hasValidReservation = reservationQuery.docs.isNotEmpty;
    // 업데이트할 데이터
    final data = {'idInReservation': hasValidReservation};

    // Child 컬렉션 내의 해당 문서 업데이트
    await _firestore
        .collection('Child')
        .doc(currentChild?.email)
        .update(data);

    setState(() {
      // 상태를 업데이트하고 화면을 다시 그립니다.
      idInReservation = hasValidReservation;
    });
  }
  Size? size;
  Size? _getSize() {
    if (_containerkey.currentContext != null) {
      final RenderBox renderBox =
      _containerkey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
  }

  @override
  void initState() {
    super.initState();
    checkAndUpdateReservationStatus();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        size = _getSize();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            CustomGoogleMap(),
            ChildMainSearch(),
            StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('Restaurant').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  return DraggableScrollableSheet(
                    // 결과 높이를 구해서 maxChildSize로 설정해야함.
                    initialChildSize: 0.15,
                    maxChildSize: 0.8,
                    minChildSize: 0.15,
                    builder: (BuildContext context, ScrollController scrollController) {
                      //return
                      //  ScrollingRestaurants();
                      return ListView(
                        key: _containerkey,
                        controller: scrollController,
                        children: [CustomScrollViewContent()],
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),

          ],
        )
    );
  }
}
