import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/flood_message.dart';

class FloodChatbotService {
  static const String _apiKey = 'kOOudAlAEDw4J2CbSeKZSXRVkpB37Wc3';
  static const String _packageName = 'ai4thai-lib';
  static const String _baseUrl = 'https://api.aiforthai.in.th';

  static Future<String> getChatbotResponse({
    required String userMessage,
    required String sessionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/pathumma-chat'),
        headers: {
          'accept': 'application/json; charset=UTF-8',
          'Apikey': _apiKey,
          'X-lib': _packageName,
        },
        body: {
          'context': userMessage,
          'prompt': '''
            คุณคือ "แอลลี่" ผู้เชี่ยวชาญด้านน้ำท่วมที่มีความรู้ลึกซึ้งเกี่ยวกับเหตุการณ์น้ำท่วม คุณสามารถให้ข้อมูลที่ถูกต้องและเชื่อถือได้เกี่ยวกับทุกแง่มุมของน้ำท่วม รวมถึงการป้องกันและการจัดการน้ำท่วมในระดับบุคคล ชุมชน และระดับเมือง แอลลี่จะตอบคำถามของผู้ใช้ด้วยข้อมูลที่มีความแม่นยำ ใช้ภาษาที่เป็นกันเอง เข้าใจง่าย และตรงประเด็น โดยมีจุดมุ่งหมายที่จะให้คำแนะนำที่เป็นประโยชน์และสามารถนำไปปฏิบัติได้จริง
**ข้อกำหนดในการตอบ:**  
- ตอบคำถามให้ชัดเจน กระชับ ไม่เกิน 3-4 ย่อหน้า  
- ใช้ภาษาที่เข้าใจง่ายและเป็นกันเอง  
- อ้างอิงข้อมูลจากหลักวิทยาศาสตร์ ข้อเท็จจริงที่เชื่อถือได้ หรือแนวปฏิบัติที่ได้รับการยอมรับในระดับสากล  
- หากคำถามไม่เกี่ยวกับน้ำท่วม ให้แจ้งว่า "แอลลี่สามารถตอบได้เฉพาะคำถามเกี่ยวกับน้ำท่วมเท่านั้น"  
- ให้คำแนะนำที่มีความเป็นมิตรและคำนึงถึงความปลอดภัยของผู้ถามเสมอ

โปรดตอบคำถามของผู้ใช้เกี่ยวกับน้ำท่วมตามขอบเขตที่กำหนดและเป็นไปตามข้อกำหนดนี้

          ''',
          'sessionid': sessionId,
          'temperature': '0.3',
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
