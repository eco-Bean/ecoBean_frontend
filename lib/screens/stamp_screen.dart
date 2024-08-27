import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Stamp {
  final String title;
  XFile? image; // 사진 저장할 필드

  Stamp(this.title, this.image);
}

class StampScreen extends StatefulWidget {
  @override
  _StampScreenState createState() => _StampScreenState();
}

class _StampScreenState extends State<StampScreen> {
  final List<Stamp> _stamps = [
    Stamp('이메일 삭제하기', null),
    Stamp('개인손수건 사용하기', null),
    Stamp('대중교통 이용하기', null),
    Stamp('텀블러 사용하기', null),
    Stamp('전자영수증 받기', null),
    Stamp('전기,수소차 이용하기', null),
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _stamps[index].image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFCF8),
        elevation: 0,
        title: Text('마이페이지', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  '도전! 탄소중립 도장깨기',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '탄소중립 나무를 채워보세요',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/tree.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            left: MediaQuery.of(context).size.width * 0.2,
            child: _buildStampItem(context, 0),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.20,
            right: MediaQuery.of(context).size.width * 0.2,
            child: _buildStampItem(context, 1),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.37,
            left: MediaQuery.of(context).size.width * 0.15,
            child: _buildStampItem(context, 2),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.37,
            right: MediaQuery.of(context).size.width * 0.16,
            child: _buildStampItem(context, 3),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width * 0.16,
            child: _buildStampItem(context, 4),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            right: MediaQuery.of(context).size.width * 0.1,
            child: _buildStampItem(context, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildStampItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.yellow[100],
            backgroundImage: _stamps[index].image != null
                ? FileImage(File(_stamps[index].image!.path))
                : null,
            child: _stamps[index].image == null
                ? Icon(Icons.camera_alt, size: 40, color: Colors.black)
                : null,
          ),
          SizedBox(height: 5),
          Text(_stamps[index].title, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
