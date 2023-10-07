import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../tab_restaurant_screen/tab_container_screen.dart';

/// Content of the DraggableBottomSheet's child SingleChildScrollView
class CustomScrollViewContent extends StatelessWidget {
  const CustomScrollViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height : screenHeight,
      child: Card(
        color: Colors.white,
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: const CustomInnerContent(),
        ),
      ),
    );
  }
}

class CustomInnerContent extends StatelessWidget {
  const CustomInnerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        CustomDraggingHandle(),
        const SizedBox(height: 16),
        ScrollingRestaurants(),
      ],
    );
  }
}

/// 모달 창에서 위에 있는 손잡이
class CustomDraggingHandle extends StatelessWidget {
  const CustomDraggingHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

/// 모달 창 안에 있는 식당 리스트
class ScrollingRestaurants extends StatelessWidget {
  StreamController<String> streamController = StreamController<String>();

// 이미지 다운로드 함수
  Future<String> downloadImage(String imagePath) async {
    Reference reference = FirebaseStorage.instance.ref(imagePath);
    String downloadURL = await reference.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        // child: SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Restaurant').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return Column(children: [
                ResultText(docs.length),
                const SizedBox(height: 16),
                Center(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final restaurantData = docs[index].data();
                    final ownerId = docs[index].id;
                    return RestaurantCard(
                      docs[index].get('name'),
                      docs[index].get('address1'),
                      docs[index].get('closeH'),
                      docs[index].get('closeM'),
                      docs[index].get('banner'),
                      ownerId,
                      //collection이름?
                    );
                  },
                ))
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(), // 데이터를 기다리는 동안 로딩 표시
              );
            }
          },
        ));
  }
}

class RestaurantCard extends StatelessWidget {
  String name;
  String address;
  String closeH;
  String closeM;
  String image;
  String ownerId; // Firestore collection 이름을 저장할 변수

  RestaurantCard(this.name, this.address, this.closeH, this.closeM, this.image,
      this.ownerId,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomRestaurantCategory(
          name, address, "$closeH : $closeM까지 영업", image, ownerId),
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
  final String title;
  final String location;
  final String time;
  final String image;
  final String collectionName; // Firestore collection 이름을 저장할 변수
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
                                  builder: (context) => TabContainerScreen(
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