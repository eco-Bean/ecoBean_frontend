import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isExpanded = false; // 필터 버튼 상태 추적
  List<dynamic> locations = []; // API로 받은 위치 정보 리스트
  bool isLoading = true; // 데이터 로딩 상태
  String filteredCategory = ''; // 필터 상태를 추적할 변수
  NaverMapController? _mapController; // NaverMapController 인스턴스

  @override
  void initState() {
    super.initState();
    fetchLocations(); // API에서 위치 데이터 가져오기
  }

  // API 호출해서 위치 정보 가져오기
  Future<void> fetchLocations() async {
    try {
      final response =
          await http.get(Uri.parse('https://moodoodle.store/map/location'));

      if (response.statusCode == 200) {
        // 응답 본문을 UTF-8로 디코딩
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);

        setState(() {
          locations = data['responseDto']['location']; // 위치 데이터 저장
          isLoading = false; // 로딩 완료
        });
      } else {
        print('Failed to load locations');
        setState(() {
          isLoading = false; // 로딩 실패
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // 로딩 실패
      });
    }
  }

  // 필터 버튼 클릭 시 필터 상태 업데이트 및 마커 업데이트
  void _updateFilter(String category) {
    setState(() {
      filteredCategory = category;
      // 필터링된 마커만 다시 추가
      _addMarkers();
    });
  }

  // 마커 추가
  void _addMarkers() {
    if (_mapController == null) return;

    _mapController!.clearOverlays(); // 기존 마커 제거

    for (var location in locations) {
      if (filteredCategory == '' || location['category'] == filteredCategory) {
        final marker = NMarker(
          id: location['name'],
          position: NLatLng(location['latitude'], location['longitude']),
        );
        _mapController!.addOverlay(marker);

        // 마커 클릭 시 팝업 호출
        marker.setOnTapListener((NMarker marker) {
          _showPopup(marker, location['description'], location['address'],
              location['category']);
        });
      }
    }
  }

  // 마커 클릭 시 팝업 표시
  void _showPopup(
      NMarker marker, String description, String address, String category) {
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
                  marker.info.id, // 마커 이름
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF401D1D)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50), // 텍스트와 아이콘 사이 간격
              if (category == '전자영수증')
                const Icon(
                  Icons.receipt_long, // 예시 아이콘
                  size: 60,
                  color: Color(0xFFFFD67D),
                ),
              if (category == '시장')
                const Icon(
                  Icons.shopping_bag, // 예시 아이콘
                  size: 60,
                  color: Color(0xFFFFD67D),
                ),
              if (category == '친환경' || category == '리필스테이션&친환경 매장')
                const Icon(
                  Icons.eco, // 예시 아이콘
                  size: 60,
                  color: Color(0xFFFFD67D),
                ),
              if (category == '텀블러')
                const Icon(
                  Icons.coffee_sharp, // 예시 아이콘
                  size: 60,
                  color: Color(0xFFFFD67D),
                ),
              const SizedBox(height: 20),
              Text(
                description, // 마커 설명
                style: const TextStyle(fontSize: 16, color: Color(0xFF401D1D)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "주소\n$address", // 주소
              style: const TextStyle(fontSize: 16, color: Color(0xFF401D1D)),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                  },
                  child: const Text('닫기'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
          : Stack(
              children: [
                NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                        target: const NLatLng(36.63581, 127.4913), zoom: 14),
                  ),
                  onMapReady: (controller) {
                    _mapController = controller; // 컨트롤러 저장
                    _addMarkers(); // 마커 추가
                    print("네이버 맵 로딩 완료!");
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
                          _updateFilter('친환경');
                        }),
                        const SizedBox(height: 10),
                        _buildFilterButton('시장', () {
                          _updateFilter('시장');
                        }),
                        const SizedBox(height: 10),
                        _buildFilterButton('전자 영수증', () {
                          _updateFilter('전자영수증');
                        }),
                        const SizedBox(height: 10),
                        _buildFilterButton('전체 보기', () {
                          _updateFilter('');
                        }),
                      ],
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        backgroundColor: const Color(0xFFFFD67D),
                        child: Icon(
                          _isExpanded ? Icons.close : Icons.tune,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // 필터 버튼 생성
  Widget _buildFilterButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD67D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF401D1D),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
