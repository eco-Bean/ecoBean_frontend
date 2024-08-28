import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Map<String, String>> messages = []; // 채팅 메시지 리스트
  TextEditingController _controller = TextEditingController(); // 텍스트 입력 컨트롤러
  File? _image; // 선택된 이미지 파일

  @override
  void initState() {
    super.initState();
    _addEchoMessage('안녕하세요! 저는 에코에요. 무엇을 도와드릴까요?');
  }

  void _addEchoMessage(String message) {
    setState(() {
      messages.add({'sender': 'echo', 'message': message});
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'user', 'message': message});
        _controller.clear(); // 입력창 비우기
      });

      // AI 백엔드로 요청 전송 및 응답 처리
      try {
        String responseMessage = await _getAIResponse(message);
        _addEchoMessage(responseMessage);
      } catch (e) {
        _addEchoMessage('에러가 발생했습니다: $e');
      }
    }
  }

  Future<String> _getAIResponse(String message) async {
    String url =
        'https://moodoodle.store/chatting/question'; // 서버 URL을 여기에 입력하세요.

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['chattingQuestion'] = message;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'chattingImage',
        _image!.path,
      ));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        if (jsonResponse['success'] == true) {
          return jsonResponse['responseDto']['chattingAnswer'];
        } else {
          return '에러: ${jsonResponse['error']}';
        }
      } else {
        throw Exception('서버 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('요청 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 터치하면 포커스 해제
      },
      child: Scaffold(
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
            '에코',
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isEcho = message['sender'] == 'echo';
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEcho) ...[
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/icon.png'), // 에코의 이미지
                          radius: 20,
                        ),
                        SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                isEcho ? Colors.grey[200] : Color(0xFFFFD67D),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            message['message']!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (!isEcho) SizedBox(width: 10),
                    ],
                    mainAxisAlignment: isEcho
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 25, right: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메시지 입력...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.grey, // 포커스 시 기본 색상으로 설정
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.image,
                        color: Color(0xFFFFD67D)), // 이미지 선택 버튼
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFFFD67D)),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
