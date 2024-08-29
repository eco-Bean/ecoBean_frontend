import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MypageScreen extends StatefulWidget {
  @override
  _MypageScreen createState() => _MypageScreen();
}

class _MypageScreen extends State<MypageScreen> {
  TextEditingController _nicknameController = TextEditingController();
  // 프로필 사진 저장 변수
  XFile? _image;
  // 인스턴스 생성
  final ImagePicker _picker = ImagePicker();

  void _saveProfile() {
    String nickname = _nicknameController.text;
    // 닉네임 저장 로직
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('닉네임이 저장되었습니다.')),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '마이페이지',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면을 리사이즈하여 오버플로우 방지
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '프로필 설정',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                    _image != null ? FileImage(File(_image!.path)) : null,
                    child: _image == null
                        ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '닉네임',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '닉네임을 입력하세요',
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // 회원탈퇴 로직
              },
              child: Text(
                '회원탈퇴',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 270), // 여유 공간 추가
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF401D1D),
                  backgroundColor: Color(0xFFFFFAC8),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
