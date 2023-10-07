import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../child/model/model_restaurant.dart';
import '../../child/screen/tab_restaurant_screen/tab_container_screen.dart';
import 'franchise_container_screen.dart';

class SearchResult extends StatelessWidget {
  String searchContents;

  SearchResult({super.key, required this.searchContents});

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = Restaurant();
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
        ),
        body: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FutureBuilder(
              future: restaurant.getSearchRestaurantList(searchContents),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    //ResultText(docs.length),
                    const SizedBox(height: 16),
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
                  return const Center(
                    child: CircularProgressIndicator(), // 데이터를 기다리는 동안 로딩 표시
                  );
                }
              },
            )));
  }
}

class RestaurantCard extends StatelessWidget {
  Restaurant restaurant;

  RestaurantCard(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomRestaurantCategory(
          restaurant.title!, restaurant.location!, "${restaurant.closetime!}까지 영업", restaurant.image!, restaurant.id!),
      const DivideLine(),
      const SizedBox(height: 20),
    ]);
  }
}

class DivideLine extends StatelessWidget {
  const DivideLine({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
        child: SizedBox(
            width: width * 0.8,
            child: const Divider(color: Colors.grey, thickness: 1.0)));
  }
}

class ResultText extends StatelessWidget {
  int length;

  ResultText(this.length, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      //only to left align the text
      child: Row(
        children: <Widget>[
          Text("$length개 결과",
              style: const TextStyle(fontFamily: "Mainfonts", fontSize: 14))
        ],
      ),
    );
  }
}

class CustomRestaurantCategory extends StatelessWidget {
  String title;
  String location;
  String time;
  String image;
  String collectionName; // Firestore collection 이름을 저장할 변수
  String imageURL = "";

  CustomRestaurantCategory(
      this.title, this.location, this.time, this.image, this.collectionName,
      {super.key}) {
    imageURL = image; // 이미지 URL을 초기화
  }

// 이미지 다운로드 함수
  Future<String> downloadImage(String imagePath) async {
    Reference reference = FirebaseStorage.instance.ref(imagePath);
    String downloadURL = await reference.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
            width: width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(

                        /// 수정 필요
                        // 각각 해당하는 가게 정보로 넘어가야함.
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FranchiseContainerScreen(
                                        title: title,
                                        location: location,
                                        time: time,
                                        banner: imageURL,
                                        ownerId: collectionName,
                                      )));
                        },
                        child: SizedBox(
                            height: width * 0.15,
                            width: width * 0.15,
                            child: Image.network(
                              imageURL,
                              fit: BoxFit.cover,
                            ))),
                    SizedBox(width: width * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: "Mainfonts",
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: width * 0.5,
                              // 48은 아이콘과 간격 등을 고려한 값입니다. 필요에 따라 조정하세요.
                              child: Text(
                                location,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.access_time_filled, size: 17),
                            const SizedBox(width: 8),
                            Text(time,
                                style: const TextStyle(
                                    fontFamily: "Pretendard", fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: width * 0.05,
                  width: width * 0.05,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                  child: const Icon(Icons.favorite,
                      size: 12, color: Colors.black54),
                ),
              ],
            )));
  }
}
