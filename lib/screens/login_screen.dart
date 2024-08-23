import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCF8), // 배경 색상
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '에코콩',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/environment-icon.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 28,
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
                  SizedBox(height: 40),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
