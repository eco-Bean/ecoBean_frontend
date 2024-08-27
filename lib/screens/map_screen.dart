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
                // 자식 버튼들
                if (_isExpanded) ...[
                  _buildFilterButton(Icons.filter_1, () {
                    print('필터 1 클릭됨');
                  }),
                  SizedBox(width: 10),
                  _buildFilterButton(Icons.filter_2, () {
                    print('필터 2 클릭됨');
                  }),
                  SizedBox(width: 10),
                  _buildFilterButton(Icons.filter_3, () {
                    print('필터 3 클릭됨');
                  }),
                ],
                // 메인 필터 버튼
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

  Widget _buildFilterButton(IconData icon, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        backgroundColor: Color(0xFFFFD67D),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
