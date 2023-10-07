import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../child_appbar/ChildAppBar.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String pickedImagePath = "";
  File? testimage;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // Function to handle file upload
  Future uploadFile() async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    final status = await Permission.storage.request();
    if (status.isGranted) {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          pickedImagePath = image!.path;
          testimage = File(pickedImagePath);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('카드 인증 캡쳐 이미지를 선택해주세요')));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('카드 인증 완료 되기 전까지 2~3일 소요됩니다.')));
    }
    // Implement file upload logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChildAppBar(title: "카드 인증하기"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: cardNumberController,
              decoration: const InputDecoration(labelText: '바우처 카드 번호 16자리'),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '성명'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: uploadFile,
              style: ElevatedButton.styleFrom(
                // primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  // side: const BorderSide(color: Colors.red),
                ),
                minimumSize: Size(
                  MediaQuery.of(context).size.width - 32,
                  48,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.upload_file, // You can change this to an appropriate icon
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '카드 인증 화면 캡쳐 업로드',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (pickedImagePath != "")
                      SizedBox(
                        width: 150,
                        height: 100,
                        child:Image.file(
                          File(pickedImagePath),
                          fit: BoxFit.cover
                        )
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}