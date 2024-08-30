import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isExpanded = false; // 필터 버튼이 눌렸는지 상태를 추적
  void _showPopup(NMarker marker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFFFFCF8),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  marker.info.id,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF401D1D)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50), // 텍스트와 아이콘 사이의 간격
              Icon(
                Icons.store, // 시장 아이콘
                size: 60,
                color: Color(0xFFFFD67D),
              ),
              SizedBox(height: 20),
              Text(
                "지역상품을 이용하는 것도 탄소중립을 실천하는 행위에요!",
                style: TextStyle(fontSize: 16, color: Color(0xFF401D1D)),
                textAlign: TextAlign.center,
              )
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "주소\n충청북도 청주시 상당구 석교동 60-4",
              style: TextStyle(fontSize: 16, color: Color(0xFF401D1D)),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 창 닫기
                  },
                  child: Text('닫기'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var map;
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
            options: NaverMapViewOptions(
                //var jeju = new naver.maps.LatLng(33.3590628, 126.534361);
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(36.63581, 127.4913), zoom: 14)),
            onMapReady: (controller) {
              final marker = NMarker(
                  id: "육거리 종합시장", position: NLatLng(36.627830, 127.488453));
              controller.addOverlay(marker);

              marker.setOnTapListener((NMarker marker) {
                // 마커를 클릭했을 때 실행할 코드
                _showPopup(marker);
              });
              print("네이버 맵 로딩됨!");
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isExpanded) ...[
                  _buildFilterButton('친환경 매장', () {
                    print('친환경 매장 클릭됨');
                  }),
                  SizedBox(height: 10),
                  _buildFilterButton('시장', () {
                    print('시장 클릭됨');
                  }),
                  SizedBox(height: 10),
                  _buildFilterButton('전자 영수증', () {
                    print('전자 영수증 클릭됨');
                  }),
                ],
                SizedBox(height: 10),
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        width: 140,
        decoration: BoxDecoration(
          color: Color(0xFFFFD67D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.brown,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
