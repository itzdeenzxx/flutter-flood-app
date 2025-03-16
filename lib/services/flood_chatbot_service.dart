import 'package:http/http.dart' as http;
import 'dart:convert';

class FloodChatbotService {
  static const String _apiKey = 'kOOudAlAEDw4J2CbSeKZSXRVkpB37Wc3';
  static const String _packageName = 'ai4thai-lib';
  static const String _baseUrl = 'https://api.aiforthai.in.th';

  static Future<String> getChatbotResponse({
    required String conversationHistory,
    required String userMessage,
    required String sessionId,
  }) async {
    try {
      // สร้าง context เพื่อส่งให้โมเดล (รวมบทบาท + ประวัติ + คำถาม)
      final String context = '''
คุณคือ "แอลลี่" ผู้หญิงที่เชี่ยวชาญด้านน้ำท่วมที่มีความรู้ลึกซึ้งเกี่ยวกับเหตุการณ์น้ำท่วม 
บทสนทนาก่อนหน้า:
$conversationHistory

คำถามล่าสุดจากผู้ใช้: "$userMessage"
''';

      // ให้ prompt เป็นคำสั่งสั้น ๆ
      final String prompt = 'โปรดตอบคำถามของผู้ใช้อย่างเป็นกันเองและกระชับ';

      final response = await http.post(
        Uri.parse('$_baseUrl/pathumma-chat'),
        headers: {
          'accept': 'application/json; charset=UTF-8',
          'Apikey': _apiKey,
          'X-lib': _packageName,
        },
        body: {
          'context': context,
          'prompt': prompt,
          'sessionid': sessionId,
          // ลองปรับค่า temperature ดูได้ตามใจชอบ
          'temperature': '0.5',
        },
      ).timeout(const Duration(seconds: 30));

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded['response'] ??
          'ขออภัยค่ะ ฉันไม่สามารถประมวลผลข้อความของคุณได้ในขณะนี้';
    } catch (e) {
      return 'ขออภัยค่ะ เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาลองใหม่อีกครั้งในภายหลัง';
    }
  }
}
