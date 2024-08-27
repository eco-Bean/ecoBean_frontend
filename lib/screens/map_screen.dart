import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MapScreen> {
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
          )),
      extendBodyBehindAppBar: true,
      body: NaverMap(
        options: const NaverMapViewOptions(),
        onMapReady: (controller) {
          print("네이버 맵 로딩됨!");
        },
      ),
    );
  }
}
