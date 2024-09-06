import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StoreScreen> {
  XFile? _image;
  void _showPopup(String title, String pay) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Color(0xFF401D1D), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(pay,
                style: TextStyle(fontSize: 16, color: Color(0xFF401D1D)),
                textAlign: TextAlign.center),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 창 닫기
                  },
                  child: Text('구매하기'),
                ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF401D1D)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '상점 페이지',
          style: TextStyle(
            color: Color(0xFF401D1D),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(10.0),
            constraints: BoxConstraints(
              minHeight: 200,
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _image != null ? FileImage(File(_image!.path)) : null,
                  child: _image == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        )
                      : null,
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 20),
                        Text(
                          '탄소저리가',
                          style: TextStyle(
                            color: Color(0xFF401D1D),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '포인트',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 20),
                        Text(
                          '1,000',
                          style: TextStyle(
                            color: Color(0xFF401D1D),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 35),
                  Text(
                    '아이템',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        _showPopup('에코 말버릇 변경권', '1,000');
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        padding: EdgeInsets.all(16.0),
                        constraints: BoxConstraints(
                          minHeight: 150,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 250, 200),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              'assets/images/icon.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' 에코 말버릇 변경권',
                                style: TextStyle(color: Color(0xFF401D1D)),
                              ),
                              SizedBox(height: 10),
                              Text(
                                ' 챗봇 에코의 말버릇을 \n원하는 말로 변경할 수 있어요!',
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFF401D1D)),
                              )
                            ],
                          )
                        ]),
                      )),
                  SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        _showPopup('에코 외형 변경권', '1,000');
                      },
                      child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          padding: EdgeInsets.all(16.0),
                          constraints: BoxConstraints(
                            minHeight: 150,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 250, 200),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.asset(
                                  'assets/images/change.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' 에코 외형 변경권',
                                    style: TextStyle(color: Color(0xFF401D1D)),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    ' 챗봇 에코의 외형을 원하는\n외형으로 변경할 수 있어요!',
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xFF401D1D)),
                                  )
                                ],
                              )
                            ],
                          ))),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _showPopup('에코 치장 아이템 교환권', '1,000');
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      padding: EdgeInsets.all(16.0),
                      constraints: BoxConstraints(
                        minHeight: 150,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 250, 200),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              'assets/images/ribboneco.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' 에코 치창 아이템 교환권',
                                style: TextStyle(color: Color(0xFF401D1D)),
                              ),
                              SizedBox(height: 10),
                              Text(
                                ' 챗봇 에코를 꾸며줄 수 있는\n치장 아이템을 교환할 수 있어요!',
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xFF401D1D)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
