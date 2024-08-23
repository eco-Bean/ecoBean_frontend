import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCF8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(
              '에코콩',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 68),

            Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/environment-icon.png',
                height: 100,
              ),
              SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '친환경\n',
                      style: TextStyle(color: Color(0xFF401D1D)),
                    ),
                    TextSpan(
                      text: '탄소중립\n',
                      style: TextStyle(color: Color(0xFF6F9978)),
                    ),
                    TextSpan(
                      text: '에코콩과\n',
                      style: TextStyle(color: Color(0xFFFFD67D)),
                    ),
                    TextSpan(
                      text: '함께 실천해요!',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),

              //소셜 로그인 버튼 ~~ 일단 임시로 이미지 넣음
              GestureDetector(
                onTap: () {
                  // 네이버 로그인 버튼
                },
                child: Image.asset(
                  'assets/images/naver_login.png',
                  height: 60,  // 원하는 높이로 설정
                  width: 320,
                ),
              ),

            ],
          ),
        ),
          ],
        ),
      ),
    );
  }
}
