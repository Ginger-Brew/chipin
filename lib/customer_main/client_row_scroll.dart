import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientRowScroll extends StatelessWidget {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          height: 200,
          child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              controller: PageController(viewportFraction: 0.7),
              itemCount: clientImgInfoList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                          image: Image.asset(clientImgInfoList[index].img).image,
                          fit: BoxFit.cover
                      )
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(clientImgInfoList[index].title),
                            Text(clientImgInfoList[index].info),
                            TextButton(
                                onPressed: () {},
                                child: Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '더보기',
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),
                                            ),],
                                        )
                                    )
                                )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(clientImgInfoList.length, (index) => Indicator(
                isActive: _selectedIndex == index ? true : false
            ))
          ],
        ),
      ],
    );
  }

  void setState(Null Function() param0) {}

}

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({
    Key? key,
    required this.isActive
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive? 22.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
          color: isActive? Colors.orange : Colors.grey,
          borderRadius: BorderRadius.circular((8.0))
      ),
    );
  }
}

class ClientImgInfo {
  final String title;
  final String info;
  final String img;

  ClientImgInfo(this.title, this.info, this.img);
}

List<ClientImgInfo> clientImgInfoList = [
  ClientImgInfo('수저세트', '수저세트를 드립니다', 'assets/images/client_img/spoon.jpg'),
  ClientImgInfo('숟가락', '숟가락입니다', 'assets/images/client_img/spoon.jpg'),
  ClientImgInfo('진짜 숟가락', '진짜라니까', 'assets/images/client_img/spoon.jpg')
];
