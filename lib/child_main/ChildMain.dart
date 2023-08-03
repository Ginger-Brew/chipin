import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class ChildMain extends StatefulWidget {
  @override
  _ChildMainState createState() => _ChildMainState();
}

class _ChildMainState extends State<ChildMain> {
  Completer<NaverMapController> _controller = Completer();
  MapType _mapType = MapType.Basic;


  int value = 2;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('NaverMap Test')),
      body: Stack(
        children: [
          Container(
            child: NaverMap(
              onMapCreated: onMapCreated,
              mapType: _mapType,
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  value = 1;
                });
              },
              child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.teal),
                  child: Center(
                    child: Text(
                      'Show Bottom Sheet',
                    ),
                  )),
            ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(
                0,
                value == 0
                    ? size.height
                    : value == 1
                        ? size.height * 0.8
                        : value == 2
                            ? size.height * 0.6
                            : value == 3
                                ? size.height * 0.4
                                : value == 4
                                    ? size.height * 0.2
                                    : value == 5
                                        ? 0
                                        : size.height,
                0),
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), color: Colors.teal),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (value > 5) {
                          value = 0;
                        }
                        value++;
                      });
                    },
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      setState(() {
                        value--;
                      });
                    },
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                      width: size.width * 0.9,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white70),
                      child: Center(
                        child: Text(
                          'Store1',
                        ),
                      )),
                  // Card(
                  //   clipBehavior: Clip.antiAlias,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(16.0),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       //모서리가 둥근 이미지
                  //       Expanded(
                  //         child: Container(
                  //           width: double.infinity,
                  //           margin: EdgeInsets.all(8.0),
                  //           decoration: BoxDecoration(
                  //             borderRadius:
                  //             BorderRadius.circular(16.0),
                  //           ),
                  //           clipBehavior: Clip.antiAlias,
                  //           //Hero 페이지 애니메이션을 적용하기 위한 위젯
                  //           child: Hero(
                  //             tag: 1,
                  //             child: Container()
                  //             // tag: index,
                  //             // Image.network(
                  //             //   snapshot.data[index]['url']
                  //             //       .toString(),
                  //             // ),
                  //           ),
                  //         ),
                  //       ),
                  //       // 메세지
                  //       Text(
                  //         "text"
                  //         // snapshot.data[index]['msg'].toString(),
                  //       ),
                  //       Row(
                  //         children: [
                  //           // 코멘트 아이콘
                  //           IconButton(
                  //             onPressed: () {  },
                  //             //상세 페이지로 이동(hero애니메이션 적용)
                  //             // onPressed: () => Navigator.push(
                  //             //   context,
                  //             //   MaterialPageRoute(
                  //             //     builder: (context) => CommentPage(
                  //             //       image: snapshot.data[index]
                  //             //       ['url'],
                  //             //       msg: snapshot.data[index]
                  //             //       ['msg'],
                  //             //       heroTag: index,
                  //             //     ),
                  //             //   ),
                  //             // ),
                  //             color: Colors.grey,
                  //             icon: Icon(Icons.comment),
                  //           ),
                  //           //좋아요 버튼(누르면 색상 변경)
                  //           GestureDetector(
                  //             // onTap: () {
                  //             //   likes[index] = !likes[index];
                  //             //   box.put('likes',
                  //             //       likes); //좋아요 리스트를 box에 저장
                  //             //   setState(() {});
                  //             // },
                  //             child: Icon(
                  //               color : Colors.red,
                  //               // color: likes[index]
                  //               //     ? Colors.red
                  //               //     : Colors.grey,
                  //               Icons.favorite,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}
