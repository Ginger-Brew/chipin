import 'dart:io';

import 'package:chipin/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../child_appbar/ChildAppBar.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}
User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;

    final amailVerified = user.emailVerified;
    final uid = user.uid;
  }
  return user;
}
class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String pickedImagePath = "";
  String CardNumber = "";
  String CardName = "";
  File? testimage;
  User? currentUser = getUser();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool inputsValid = false;
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
          updateInputsValid();
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
  void requestAuthentication() async{
    if (inputsValid) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String userEmail = currentUser.email ?? "";

          await FirebaseFirestore.instance.collection("Child").doc(userEmail).update({
            "CardNumber": CardNumber,
            "CardName": CardName,
          });

          await uploadImageToStorage(userEmail);

          Navigator.pop(context);
        }
      } catch (e) {
        print("Error requesting authentication: $e");
        // Handle the error (e.g., show a snackbar)
      }
    }
     }
  @override
  void initState() {
    super.initState();

    // Listen to changes in the cardNumberController
    cardNumberController.addListener(() {
      setState(() {
        CardNumber = cardNumberController.text;
        updateInputsValid();
      });
    });

    // Listen to changes in the nameController
    nameController.addListener(() {
      setState(() {
        CardName = nameController.text;
        updateInputsValid();
      });
    });
  }
  void updateInputsValid() {
    // Check if all input fields have valid values
    inputsValid = CardNumber.length == 16 && CardName.isNotEmpty && pickedImagePath.isNotEmpty;
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
            Column(
              children: [
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
                  child: const Row(
                    children: [
                      Icon(
                        Icons.upload_file, // You can change this to an appropriate icon
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '카드 인증 화면 캡쳐 업로드',
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (pickedImagePath != "")
                  SizedBox(
                    width: 150,
                    height: 100,
                    child: Image.file(
                      File(pickedImagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: inputsValid ? requestAuthentication : null,
              style: TextButton.styleFrom(
                // primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  // side: const BorderSide(color: Colors.red),
                ),
                minimumSize: Size(
                  MediaQuery.of(context).size.width - 32,
                  48,
                ),
                backgroundColor: inputsValid ? MyColor.DARK_YELLOW : Colors.grey, // Adjust the color based on input validation
              ),
              child: const Text(
                '인증 요청하기',
                style: TextStyle(
                  fontFamily: "Pretendard",
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImageToStorage(String userEmail) async {
    try {
      if (testimage != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref("cardInfo/$userEmail.jpg"); // Specify the file path and name

        await storageRef.putFile(testimage!); // Upload the image file

        print("Image uploaded successfully");
      }
    } catch (e) {
      print("Error uploading image to storage: $e");
      // Handle the error (e.g., show a snackbar)
    }
  }
}