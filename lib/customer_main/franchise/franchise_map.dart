import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'childmain_scrollview.dart';
import 'franchise_google_map.dart';
import 'franchise_search.dart';


class FranchiseMap extends StatefulWidget {
  const FranchiseMap({super.key});

  @override
  State<FranchiseMap> createState() => _FranchiseMapState();
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

class _FranchiseMapState extends State<FranchiseMap> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentChild = getUser();
  final GlobalKey _containerkey = GlobalKey();

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
            FranchiseGoogleMap(),
            FranchiseSearch(),
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
                        children: [FranchiseScrollViewContent()],
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
