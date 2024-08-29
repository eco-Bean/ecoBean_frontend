import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isExpanded = false; // 필터 버튼이 눌렸는지 상태를 추적

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(),
            onMapReady: (controller) {
              print("네이버 맵 로딩됨!");
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isExpanded)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
                    child: Row(
                      children: [
                        _buildFilterButton('친환경 매장', () {
                          print('친환경 매장 클릭됨');
                        }),
                        SizedBox(width: 10),
                        _buildFilterButton('시장', () {
                          print('시장 클릭됨');
                        }),
                        SizedBox(width: 10),
                        _buildFilterButton('전자 영수증', () {
                          print('전자 영수증 클릭됨');
                        }),
                        // 필요한 만큼 추가 버튼 생성 가능
                      ],
                    ),
                  ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  backgroundColor: Color(0xFFFFD67D),
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.filter_alt,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 50,
      width: 110, // 버튼의 가로 넓이
      child: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        backgroundColor: Color(0xFFFFD67D),
        child: Text(
          text,
          style: TextStyle(color: Colors.brown, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
