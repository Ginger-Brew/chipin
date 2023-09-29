import 'package:flutter/material.dart';

import '../../../core/utils/size_utils.dart';
import '../../model/model_report.dart';
import '../../service/review_service.dart';
import '../report/report_detail.dart';

// ignore_for_file: must_be_immutable
class thanks extends StatefulWidget {
  const thanks({Key? key})
      : super(
    key: key,
  );

  @override
  thanksState createState() => thanksState();
}

class thanksState extends State<thanks>
    with AutomaticKeepAliveClientMixin<thanks> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    ReviewService reviewService = ReviewService();
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FutureBuilder(
          future: reviewService.getReviewList('restaurant@test.com'),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }
            else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),

                child: Text(
                  'Error!: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                  style: TextStyle(fontSize: 15),
                ),
              );
            }
            else if (snapshot.hasData) {
              print("print!");
              print(snapshot.data!);
              return Column(children: [
                SizedBox(height: 16),
                Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(snapshot.data![index]);
                      },
                    ))
              ]);
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}


class RestaurantCard extends StatelessWidget {
  Review review;

  RestaurantCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomRestaurantCategory(review),
      SizedBox(height: 20),
    ]);
  }
}

class CustomRestaurantCategory extends StatelessWidget {
  Review review;

  CustomRestaurantCategory(this.review);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(
        left: 33,
        right: 15,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Text(
                review.content!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                // style: theme.textTheme.titleLarge,
              ),
              Padding(
                padding: getPadding(
                  top: 1,
                ),
                child: Text(
                  review.childId!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  // style:
                  // theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportDetail(
                          childId : review.childId!
                      )
                  )
              );
            },
            child: const Text(
              "신고하기",
              style: TextStyle(
                fontFamily: "Mainfonts",
                color: Colors.grey, // 회색으로 설정
                fontSize: 12, // 원하는 글씨 크기 설정
              ),
            ),
          ),

        ],
      ),
    );
  }
}
