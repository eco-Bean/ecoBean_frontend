import 'package:ecobean_frontend/screens/chatbot_screen.dart';
import 'package:ecobean_frontend/screens/recycling_screen.dart';
import 'package:ecobean_frontend/screens/stamp_screen.dart';
import 'package:ecobean_frontend/screens/map_screen.dart';
import 'package:ecobean_frontend/screens/store_screen.dart';
import 'package:ecobean_frontend/screens/store_screen.dart';
import 'package:ecobean_frontend/screens/upload_image_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'mypage_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String dailyMission1 = '전자영수증 발급 받기';
  final String dailyMission2 = '버스 1회 탑승하기';
  final String knowledgeText = '우리 지역 생산품 소비하기';

  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
        // 팝업 띄우기
        showDialog(
          context: context,
          barrierDismissible: false, // 팝업 바깥을 터치해도 닫히지 않도록 설정
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFFFFAC8),
              content: Row(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '에코가 열심히 분석해드릴게요.\n잠시만 기다려 주세요!',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        try {
          final recycleAnswer = await uploadImageAndGetResponse(pickedFile);

          // 팝업 닫기
          Navigator.of(context).pop();

          // 팝업이 완전히 닫힌 후에 라우팅 수행
          await Future.delayed(Duration(milliseconds: 300)); // 지연 추가
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecyclingScreen(
                capturedImage: pickedFile,
                recycleAnswer: recycleAnswer,
              ),
            ),
          );
        } catch (e) {
          // 에러 처리
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지 업로드에 실패했습니다. 다시 시도해 주세요.')),
          );
        }
    }
  }

  void _launchURL() async {
    const url = 'https://www.naver.com'; // 이동할 링크
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '에코콩',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.brown),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          color: Color(0xFFFFFAC8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150), // 상단 간격 추가
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MypageScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Icon(
                          Icons.settings,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '탄소저리가',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/challenge.png',
                      width: 30,
                      height: 30,
                    ),
                    title: Text('도전과제'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StampScreen()),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/store.png',
                      width: 30,
                      height: 30,
                    ),
                    title: Text('상점'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StoreScreen()),
                      );
                    },
                  ),
                ),
              ),
              Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // 로그아웃 로직 추가
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 5), // 간격 조정
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              '일일 미션',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(
                minHeight: 120,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      dailyMission1,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      dailyMission2,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              '지식+',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  knowledgeText,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: _launchURL,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/event.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFFFFAC8),
        selectedItemColor: Color(0xFF401D1D),
        unselectedItemColor: Color(0xFF401D1D),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.camera_alt, color: Color(0xFF401D1D)),
              onPressed: _openCamera,
            ),
            label: '카메라',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.assignment, color: Color(0xFF401D1D)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StampScreen()),
                );
              },
            ),
            label: '스탬프',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home, color: Color(0xFF401D1D)),
              onPressed: () {

              },
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.map, color: Color(0xFF401D1D)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
            label: '지도',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.chat, color: Color(0xFF401D1D)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotScreen()),
                );
              },
            ),
            label: '채팅',
          ),
        ],
      ),
    );
  }
}