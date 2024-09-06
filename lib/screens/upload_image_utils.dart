import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

//이미지 업로드 함수
Future<Map<String, String>?> uploadImageAndGetResponse(XFile image) async {
  try {
    final url = Uri.parse('https://moodoodle.store/chatting/recycle');
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath(
        'recycleImage',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await request.send();

    // 서버 응답 내용 확인
    final responseBody = await response.stream.bytesToString();
    print('Response Body: $responseBody');
    print('image_path: ${image.path} ');
    print(request.fields['rectcleImage']);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(responseBody);

      if (decodedResponse['success']) {
        final recycleAnswer = decodedResponse['responseDto']['recycleAnswer'] as String;
        final recycleItem = decodedResponse['responseDto']['recycleItem'] as String;

        return {
          'recycleAnswer': recycleAnswer,
          'recycleItem': recycleItem,
        };
      } else {
        print('Error: ${decodedResponse['error']?.toString()}');
        return null;
      }
    } else {
      print('Failed to upload image with status code: ${response.statusCode}');
      print('Response Body: $responseBody');
      return null;
    }
  } catch (e) {
    print('Exception during image upload: $e');
    return null;
  }
}