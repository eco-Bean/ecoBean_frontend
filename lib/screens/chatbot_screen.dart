import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Map<String, String>> messages = []; // 채팅 메시지 리스트
  TextEditingController _controller = TextEditingController(); // 텍스트 입력 컨트롤러

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

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'user', 'message': message});
        _controller.clear(); // 입력창 비우기
      });
      _addEchoMessage('에코가 받은 메시지: $message');
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
