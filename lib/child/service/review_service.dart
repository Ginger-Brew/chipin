import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/model_report.dart';

class ReviewService {
  static final ReviewService _reviewService = ReviewService._internal();

  factory ReviewService() {
    return _reviewService;
  }

  ReviewService._internal() {
    //getUserEmail();
  }

  void createReview() {}

  Future<List<Review>> getReviewList(String nowRestaurantId) async {
    List<Review> _reviews = [];

    await FirebaseFirestore.instance.collection("Review").get().then(
          (querySnapshot) {
        for (var review in querySnapshot.docs) {
          Review _review = Review();
          // querySnapshot.docs.data() => Map
          _review.fromJson(review.data());
          if (_review.restaurantId == nowRestaurantId) {
            _reviews.add(_review);
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return _reviews;
  }
}
