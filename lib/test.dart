import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('이미지 업로드 예제'),
        ),
        body: ImageUploader(),
      ),
    );
  }
}

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('이미지를 선택해주세요.'),
      ));
      return;
    }

    final Reference storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
    final UploadTask uploadTask = storageRef.putFile(_imageFile!);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    final String downloadURL = await snapshot.ref.getDownloadURL();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('이미지 업로드 완료'),
    ));
    print('Download URL: $downloadURL');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageFile != null
            ? Image.file(_imageFile!)
            : Placeholder(
          fallbackHeight: 200,
          fallbackWidth: double.infinity,
        ),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('이미지 선택'),
        ),
        ElevatedButton(
          onPressed: _uploadImage,
          child: Text('이미지 업로드'),
        ),
      ],
    );
  }
}
