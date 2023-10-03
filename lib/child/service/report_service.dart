import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/model_report.dart';

class ReportService {
  static final ReportService _reviewService = ReportService._internal();

  factory ReportService() {
    return _reviewService;
  }

  ReportService._internal() {
    //getUserEmail();
  }

  void createReport(String reason, Review review) {
    String? userid = FirebaseAuth.instance.currentUser!.email;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore
        .collection('Review')
        .doc(review.reviewId)
    .collection('Report')
    .doc()
        .set({
      'reason' : reason,
      'reporterId' : userid
    });
  }

  Future<void> checkReportCount(Review review) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    AggregateQuerySnapshot query = await _firestore
        .collection('Review')
        .doc(review.reviewId)
        .collection('Report')
        .count()
        .get();
    int reportCount = query.count;

    if (reportCount >= 5) {
      _firestore
          .collection('Review')
          .doc(review.reviewId)
          .delete();
    }
  }
}
