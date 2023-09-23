import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/utils/size_utils.dart';
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

    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: StreamBuilder(
          stream:
          FirebaseFirestore.instance.collection('Review').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return Column(children: [
                SizedBox(height: 16),
                Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                            docs[index].get('childId'),
                            docs[index].get('restaurantId'),
                            docs[index].get('content'),
                            docs[index].get('childNickname'));
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
  String childId;
  String restaurantId;
  String content;
  String childNickname;

  RestaurantCard(this.childId, this.restaurantId, this.content, this.childNickname);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomRestaurantCategory(
          childId, restaurantId, content, childNickname),
      SizedBox(height: 20),
    ]);
  }
}

class CustomRestaurantCategory extends StatelessWidget {
  final String childId;
  final String restaurantId;
  final String content;
  final String childNickname;

  const CustomRestaurantCategory(this.childId, this.restaurantId, this.content, this.childNickname, {super.key});

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
                content,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                // style: theme.textTheme.titleLarge,
              ),
              Padding(
                padding: getPadding(
                  top: 1,
                ),
                child: Text(
                  childId,
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
                          childId : childId
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
