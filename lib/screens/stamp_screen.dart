import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StampScreen extends StatefulWidget {
  @override
  _StampScreen createState() => _StampScreen();
}

class _StampScreen extends State<StampScreen> {
  // 각 스탬프에 해당하는 이미지 파일을 저장하는 리스트
  List<XFile?> _stamps = List<XFile?>.filled(18, null);

  int _currentPageIndex = 0; // 현재 페이지 인덱스

  // 이미지 선택 및 저장 메서드
  Future<void> _pickImage(int index) async {
    final ImagePicker _picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('카메라로 촬영하기'),
            onTap: () async {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              final pickedFile = await _picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                _saveStampImage(index, pickedFile);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('갤러리에서 선택하기'),
            onTap: () async {
              Navigator.of(context).pop();
              final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                _saveStampImage(index, pickedFile);
              }
            },
          ),
        ],
      ),
    );
  }

  // 선택한 이미지를 해당 인덱스 스탬프에 저장하는 메서드
  void _saveStampImage(int index, XFile image) {
    setState(() {
      _stamps[index] = image;
    });
  }

  // 페이지 이동 함수
  void _goToNextPage() {
    if (_currentPageIndex < 2) {
      setState(() {
        _currentPageIndex++;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PageView(
            controller: PageController(initialPage: _currentPageIndex),
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: [
              _buildStampPage(0, 0),   // 첫 번째 페이지: 스탬프 인덱스 0~5
              _buildStampPage(1, 6),   // 두 번째 페이지: 스탬프 인덱스 6~11
              _buildStampPage(2, 12),  // 세 번째 페이지: 스탬프 인덱스 12~17
            ],
          ),
          // 좌우 페이지 넘김 버튼
          if (_currentPageIndex > 0) // 인덱스가 0일 때는 left 버튼 숨기기
            Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height / 2 - 24,
              child: IconButton(
                icon: Icon(Icons.arrow_left, size: 48),
                onPressed: _goToPreviousPage,
              ),
            ),
          if (_currentPageIndex < 2) // 인덱스가 2일 때는 right 버튼 숨기기
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height / 2 - 24,
              child: IconButton(
                icon: Icon(Icons.arrow_right, size: 48),
                onPressed: _goToNextPage,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStampPage(int pageIndex, int startIndex) {
    List<String> labels = _getLabelsForPage(_currentPageIndex);

    return Stack(
      children: [
        // 배경 이미지
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          bottom: 50,
          child: Image.asset(
            'assets/images/tree.png',
            fit: BoxFit.contain,
          ),
        ),
        // 상단 텍스트
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
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // 스탬프 리스트
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStamp(startIndex, labels[0]),
                  SizedBox(width: 18),
                  _buildStamp(startIndex + 1, labels[1]),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStamp(startIndex + 2, labels[2]),
                  SizedBox(width: 18),
                  _buildStamp(startIndex + 3, labels[3]),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStamp(startIndex + 4, labels[4]),
                  SizedBox(width: 40),
                  _buildStamp(startIndex + 5, labels[5]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 페이지 인덱스에 따른 라벨 설정
  List<String> _getLabelsForPage(int pageIndex) {
    switch (_currentPageIndex) {
      case 0:
        return ['이메일 삭제하기', '개인손수건 사용하기', '나무 심기 운동 참여하기', '물은 받아서 사용하기', '전자영수증 받기', '전기,수소차 이용하기'];
      case 1:
        return ['텀블러 사용하기', '자전거 타기', '대중교통 이용하기', '리필 제품 사용하기', '식물 키우기', '친환경 상품 구매하기'];
      case 2:
        return ['불필요한 종이 없애기', '친환경 가구 사용하기', '비건 식단 실천하기', '에너지 절약하기', '재활용품 분리배출하기', '환경 캠페인 참여하기'];
      default:
        return [];
    }
  }

  Widget _buildStamp(int index, String label) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(index),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFFFFAC8),
            backgroundImage: _stamps[index] != null
                ? FileImage(File(_stamps[index]!.path))
                : null,
            child: _stamps[index] == null
                ? Icon(Icons.camera_alt, size: 30, color: Colors.black)
                : null,
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
