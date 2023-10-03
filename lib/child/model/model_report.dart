import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? reviewId;
  String? childId;
  String? restaurantId;
  String? content;
  String? childNickName;
  Timestamp? timestamp;
  //List<Report>? reports;

  Review({this.childId, this.restaurantId, this.content, this.childNickName,
    this.timestamp, /*this.reports = const []*/});

  void fromJson(String reviewId, Map<dynamic, dynamic> json) {
    this.reviewId = reviewId;
    this.childId= json['childId'];
    this.restaurantId= json['restaurantId'];
    this.content= json['content'];
    this.childNickName= json['childNickName'];
    this.timestamp= json['timestamp'];
    //reports= json['reports'].map((report) => Report.fromJson(report)).toList();
  }

  toJson() {
    return {
      'childId': this.childId,
      'restaurantId': this.restaurantId,
      'content' : this.content,
      'childNickName' : this.childNickName,
      'timestamp' : this.timestamp,
      //'reports' : this.reports?.map((report) => report.toJson()).toList()
    };
  }
}

class Report {
  String? reporterId;
  String? reason;

  Report({required this.reporterId, required this.reason});

  Report.fromJson(Map<dynamic, dynamic> json) {
    reporterId = json['reportId'];
    reason = json['reason'];
  }

  toJson() {
    return {
      'reporterId' : this.reporterId,
      'reason': this.reason
    };
  }
}