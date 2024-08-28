import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'chatbot_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class RecyclingScreen extends StatefulWidget {
  final XFile? capturedImage;

  RecyclingScreen({Key? key, this.capturedImage}) : super(key: key);


  @override
  _RecyclingScreenState createState() => _RecyclingScreenState();
}

class _RecyclingScreenState extends State<RecyclingScreen> {
  // 메인스크린에서 촬영한 사진을 저장하는 변수
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _capturedImage = widget.capturedImage;
  }

  // 데이터베이스에서 가져온 텍스트
  String itemDescription = '다이어리';
  String recyclingMethod = '커버: 일반쓰레기\n속지: 종이류';

  // 카메라 열기 함수
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = pickedFile;
      });

      // 이미지 업로드
      await _uploadImage(pickedFile);
    }
  }


  // 텍스트 복사 함수
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: recyclingMethod));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('분리수거 방법이 복사되었습니다.')),
    );
  }

  //이미지 업로드 함수
  Future<void> _uploadImage(XFile image) async {
    final url = Uri.parse('https://moodoodle.store/chatting/recycle');
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath(
        'recycleImage',
        image.path,
        contentType: MediaType('image', 'jpeg'),  // MediaType을 사용하여 contentType 지정
      ),
    );

    // request에 추가된 모든 파일과 필드를 출력
    print('Request Headers: ${request.headers}');
    print('Request Files: ${request.files}');
    print('Request Fields: ${request.fields}');

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      if (decodedResponse['success']) {
        final recycleAnswer = decodedResponse['responseDto']['recycleAnswer'];

        // recyclingMethod에 서버 응답의 recycleAnswer 값을 할당
        setState(() {
          recyclingMethod = recycleAnswer;
        });
      } else {
        // 에러 처리
        print('Error: ${decodedResponse['error']}');
      }
    } else {
      print('Failed to upload image');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '분리수거',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _capturedImage != null
                ? Image.file(
              File(_capturedImage!.path),
              height: 200,
              width: 200,
            )
                : Placeholder(fallbackHeight: 200, fallbackWidth: 200),
            SizedBox(height: 20),
            // 데이터베이스에서 가져온 텍스트
            Text(
              '[ $itemDescription ]',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // '버리는 물건이 다른가요?' 텍스트
            Text(
              '버리는 물건이 다른가요?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // 사진 재촬영 및 챗봇 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _openCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text(
                    '사진 재업로드',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    backgroundColor: Color(0xFFFFFAC8),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatbotScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.chat_bubble_outline),
                  label: Text(
                    '챗봇에게 물어보기',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    backgroundColor: Color(0xFFFFFAC8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 올바른 분리수거 방법 텍스트 박스
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  constraints: BoxConstraints(
                    minHeight: 200,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFAC8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '✔ 올바른 분리수거 방법',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        recyclingMethod,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _copyToClipboard,
                    child: Icon(
                      Icons.copy,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


