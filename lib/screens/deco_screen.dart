import 'package:flutter/material.dart';

class DecoScreen extends StatefulWidget {
  const DecoScreen({super.key});

  @override
  State<DecoScreen> createState() => _DecoScreenState();
}

class _DecoScreenState extends State<DecoScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭 (0: 치장 아이템, 1: 외형)
  String eco = 'assets/images/icon.png';
  String item = 'assets/images/basic.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: const Color(0xFF401D1D)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            '에코 꾸미기',
            style: TextStyle(
              color: Color(0xFF401D1D),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: Stack(children: [
                    Image.asset(
                      eco,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      item,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  ])),
            ),
            const Spacer(),
            Row(
              children: [
                SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0; // '치장 아이템' 선택
                    });
                  },
                  child: Stack(children: [
                    Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Color(0xFFFFFAC8)
                            : Color(0xFFFFD67D), // 선택된 색상
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text('치장 아이템'),
                      ),
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1; // '외형' 선택
                    });
                  },
                  child: Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? Color(0xFFFFFAC8)
                          : Color(0xFFFFD67D), // 선택된 색상
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text('외형'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: const Color(0xFFFFFAC8),
              ),
              height: 380,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    // 첫 번째 Stack ('치장 아이템')
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      item = 'assets/images/basic.png';
                                    });
                                  },
                                  child: Column(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image.asset(
                                            'assets/images/basic.png',
                                            width: 110,
                                          ),
                                        )),
                                    Text('아이템 빼기'),
                                  ])),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      item = 'assets/images/sunglass.png';
                                    });
                                  },
                                  child: Column(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image.asset(
                                            'assets/images/sunglass.png',
                                            width: 110,
                                          ),
                                        )),
                                    Text('선글라스'),
                                  ])),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      item = 'assets/images/sprout.png';
                                    });
                                  },
                                  child: Column(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image.asset(
                                            'assets/images/sprout.png',
                                            width: 110,
                                          ),
                                        )),
                                    Text('새싹'),
                                  ])),
                            ],
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item = 'assets/images/rribon.png';
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Image.asset(
                                            'assets/images/rribon.png',
                                            width: 110,
                                          ),
                                        )),
                                    Text('리본'),
                                  ],
                                ),
                              ),
                            ])
                      ],
                    ),
                    // 두 번째 Stack ('외형')
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      eco = 'assets/images/icon.png';
                                    });
                                  },
                                  child: Column(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        'assets/images/icon.png',
                                        width: 110,
                                      ),
                                    ),
                                    Text('기본'),
                                  ])),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      eco = 'assets/images/yeco.png';
                                    });
                                  },
                                  child: Column(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        'assets/images/yeco.png',
                                        width: 110,
                                      ),
                                    ),
                                    Text('노란 에코'),
                                  ])),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      eco = 'assets/images/beco.png';
                                    });
                                  },
                                  child: Column(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        'assets/images/beco.png',
                                        width: 110,
                                      ),
                                    ),
                                    Text('파란 에코'),
                                  ])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
