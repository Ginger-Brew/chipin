import 'package:chipin/base_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../child/model/model_child.dart';

class Information extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: SingleChildScrollView(
        // 수직 스크롤 지원
        child: FutureBuilder(
          future: loadAsset('information.txt'),
          builder: (context, snapshot) {
            var tableRows = <Text>[];
            if (!(snapshot.hasData)) {
              return CircularProgressIndicator();
            } else {
              // snapshot은 Future 클래스가 포장하고 있는 객체를 data 속성으로 전달
              // Future<String>이기 때문에 data는 String이 된다.
              final contents = snapshot.data.toString();

              // 개행 단위로 분리
              final rows = contents.split('\n');

              for (var row in rows) {
                tableRows.add(Text(row));
              }
            }
            return Column(children: tableRows);
          },
        ),
      ),
    );
  }
}

// assets 폴더 아래에 2016_GDP.txt 파일 있어야 함.
// AssetBundle 객체를 통해 리소스에 접근.
// DefaultAssetBundle 클래스 또는 미리 만들어 놓은 rootBundle 객체 사용.
// async는 비동기 함수, await는 비동기 작업이 종료될 때까지 기다린다는 뜻.
// 그러나, 함수 자체가 블록되지는 않고 예약 전달의 형태로 함수 반환됨.
// 따라서 Future 클래스를 사용하기 위해서는 FutureBuilder 등의 특별한 클래스가 필요함.
Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
  // return await DefaultAssetBundle.of(ctx).loadString('assets/2016_GDP.txt');
}
