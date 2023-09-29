import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../tab_container_screen/tab_container_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Content of the DraggableBottomSheet's child SingleChildScrollView
class CustomScrollViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: CustomInnerContent(),
      ),
    );
  }
}

class CustomInnerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        CustomDraggingHandle(),
        SizedBox(height: 16),
        ScrollingRestaurants(),
      ],
    );
  }
}

class CustomDraggingHandle extends StatelessWidget {
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
                SizedBox(height: 16),
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
              return CircularProgressIndicator();
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

  RestaurantCard(this.name, this.address, this.closeH, this.closeM, this.image, this.ownerId);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomRestaurantCategory(
          name, address, closeH + " : " + closeM + "까지 영업", image,ownerId),
      DivideLine(),
      SizedBox(height: 20),
    ]);
  }
}

class DivideLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: 350, child: Divider(color: Colors.grey, thickness: 1.0)));
  }
}

class ResultText extends StatelessWidget {
  int length;

  ResultText(this.length);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      //only to left align the text
      child: Row(
        children: <Widget>[
          Text("${length}개 결과",
              style: TextStyle(fontFamily: "Mainfonts", fontSize: 14))
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
      this.title, this.location, this.time, this.image, this.collectionName, {super.key}) {
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
    return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
            width: 340,
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
                                      )
                              )
                          );
                        },
                        child: Container(
                            height: 90,
                            width: 90,
                          child: Image.network(imageURL,
                            fit: BoxFit.cover,) // 이미지를 정사각형 비율로 크롭), // imageURL을 사용
                            // child: Image.network(
                            //     downloadImage(image) as String)
                          // child: Image.file(
                          //   File(image),
                          //   fit: BoxFit.fill,
                          // ),
                        )
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: "Mainfonts",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, size: 20),
                            SizedBox(width: 8),
                            Container(
                              width: MediaQuery.of(context).size.width - 250, // 48은 아이콘과 간격 등을 고려한 값입니다. 필요에 따라 조정하세요.
                              child: Text(
                                location,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.access_time_filled, size: 20),
                            SizedBox(width: 8),
                            Text(time, style: TextStyle(fontFamily: "Pretendard", fontSize: 15)),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.favorite, size: 12, color: Colors.black54),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(100)),
                ),
              ],
            )));
  }
}

class CustomFeaturedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
