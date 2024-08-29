import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> messages = []; // 채팅 메시지 리스트
  final TextEditingController _controller =
      TextEditingController(); // 텍스트 입력 컨트롤러
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러
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
    _scrollToBottom();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(pickedFile);
    }
  }

  Future<void> _uploadImage(XFile image) async {
    final url = Uri.parse('https://moodoodle.store/chatting/question');
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath(
        'chattingImage',
        image.path,
        contentType:
            MediaType('image', 'jpeg'), // MediaType을 사용하여 contentType 지정
      ),
    );

    // request에 추가된 모든 파일과 필드를 출력
    print(
        'Request Files: ${request.files.map((file) => file.filename).toList()}');

    // final response = await request.send();

    // if (response.statusCode == 200) {
    //   final responseBody = await response.stream.bytesToString();
    //   final decodedResponse = jsonDecode(responseBody);

    //   if (decodedResponse['success']) {
    //     final recycleAnswer = decodedResponse['responseDto']['recycleAnswer'];

    //     // recyclingMethod에 서버 응답의 recycleAnswer 값을 할당
    //     setState(() {
    //       recyclingMethod = recycleAnswer;
    //     });
    //   } else {
    //     // 에러 처리
    //     print('Error: ${decodedResponse['error']}');
    //   }
    // } else {
    //   print('Failed to upload image');
    // }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isNotEmpty || _image != null) {
      setState(() {
        messages.add({
          'sender': 'user',
          'message': message,
          'image': _image,
        });
        print(_image);

        _controller.clear(); // 입력창 비우기
        //_image = null; // 이미지 초기화
      });

      _scrollToBottom();

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
    String url = 'https://moodoodle.store/chatting/question'; // 서버 URL

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['chattingQuestion'] = message;

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'chattingImage',
          _image!.path,
          contentType:
              MediaType('image', 'jpeg'), // MediaType을 사용하여 contentType 지정
        ),
      );
    } else {
      request.fields['chattingImage'] = '';
    }
    print(
        'Request Files: ${request.files.map((file) => file.filename).toList()}');

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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
                controller: _scrollController,
                padding: const EdgeInsets.all(10.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isEcho = message['sender'] == 'echo';
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEcho) ...[
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/icon.png'), // 에코의 이미지
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isEcho
                                ? Colors.grey[200]
                                : const Color(0xFFFFD67D),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message['image'] != null)
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Image.file(
                                    message['image'],
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if (message['message'] != null &&
                                  message['message']!.isNotEmpty)
                                Text(
                                  message['message']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (!isEcho) const SizedBox(width: 10),
                    ],
                    mainAxisAlignment: isEcho
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                  );
                },
              ),
            ),
            if (_image != null)
              Align(
                child: Container(
                  alignment: Alignment.topCenter, // 왼쪽 상단에 위치

                  decoration: BoxDecoration(
                      color: const Color.fromARGB(1, 0, 0, 0).withOpacity(0.3)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10), // 모서리 굴곡

                        child: Image.file(
                          _image!,
                          height: 150, // 원하는 너비 설정
                          fit: BoxFit.contain, // 비율을 유지하면서 크기를 맞춤
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(bottom: 25),
                        icon:
                            const Icon(Icons.cancel, color: Color(0xFFFFD67D)),
                        onPressed: _removeImage,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 25, right: 5),
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
                          borderSide: const BorderSide(
                            color: Colors.grey, // 포커스 시 기본 색상으로 설정
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image, color: Color(0xFFFFD67D)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('카메라로 촬영'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_album),
                              title: const Text('갤러리에서 선택'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                            SizedBox(height: 80),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFFFD67D)),
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
