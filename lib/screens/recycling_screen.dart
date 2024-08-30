import 'dart:io';
import 'package:ecobean_frontend/screens/upload_image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'chatbot_screen.dart';


class RecyclingScreen extends StatefulWidget {
  final XFile? capturedImage;
  final String? recycleAnswer;


  RecyclingScreen({Key? key, this.capturedImage, this.recycleAnswer}) : super(key: key);


  @override
  _RecyclingScreenState createState() => _RecyclingScreenState();
}

class _RecyclingScreenState extends State<RecyclingScreen> {
  // 메인스크린에서 촬영한 사진을 저장하는 변수
  XFile? _capturedImage;
  String? recyclingMethod;

  @override
  void initState() {
    super.initState();
    _capturedImage = widget.capturedImage;
    recyclingMethod = widget.recycleAnswer ?? '정보를 불러올 수 없습니다.';
  }

    // 데이터베이스에서 가져온 텍스트
    String itemDescription = '버리는 품목 이름';

    // 카메라 열기 함수
    Future<void> _openCamera() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _capturedImage = pickedFile;
        });

        // 이미지 업로드
        await _uploadImageAndSetResponse(pickedFile);
      }
    }


    // 텍스트 복사 함수
    void _copyToClipboard() {
      Clipboard.setData(ClipboardData(text: recyclingMethod ?? ''));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('분리수거 방법이 복사되었습니다.')),
      );
    }

    //이미지 업로드 함수
    Future<void> _uploadImageAndSetResponse(XFile image) async {
      // 팝업 띄우기
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFFFFAC8),
            content: Row(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text('에코가 열심히 분석해드릴게요.\n잠시만 기다려 주세요!',
                    style: TextStyle(color: Colors.brown),),
                ),
              ],
            ),
          );
        },
      );

      final recycleAnswer = await uploadImageAndGetResponse(image);

      // 팝업 닫기
      Navigator.of(context).pop();

      if (recycleAnswer != null) {
        setState(() {
          recyclingMethod = recycleAnswer;
        });
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
                    icon: Icon(Icons.camera_alt,
                      size: 18, // 아이콘 크기를 줄였습니다.
                    ),
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
                    icon: Icon(Icons.chat_bubble_outline,
                      size: 18, // 아이콘 크기를 줄였습니다.
                    ),
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
                          recyclingMethod ?? "",
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


