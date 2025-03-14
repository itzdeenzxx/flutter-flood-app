import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/disease_analysis.dart';

class DiseaseAnalysisService {
  static const String _apiKey = 'kOOudAlAEDw4J2CbSeKZSXRVkpB37Wc3';
  static const String _packageName = 'ai4thai-lib';
  static const String _baseUrl = 'https://api.aiforthai.in.th';

  static Future<DiseaseAnalysis> analyzeDiseaseRisk({
    required String symptoms,
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
          'context': symptoms,
          'prompt': '''
            กรุณาวิเคราะห์อาการและประเมินความเสี่ยงของโรคที่อาจเกิดขึ้นจากน้ำท่วม ตามข้อมูลอาการที่ได้รับ  
              **⚠️ เงื่อนไขสำคัญ:**  
              1. วิเคราะห์เฉพาะ **โรคที่เกี่ยวข้องกับน้ำท่วม** เท่านั้น 
              2. ระบุ **ระดับความเสี่ยง** เป็น (ต่ำ, ปานกลาง, สูง)  
              3. ตอบกลับเป็น **ข้อความดิบ (Plain Text)** ในรูปแบบ **Key: Value** ตามตัวอย่างด้านล่าง  

              **🔹 รูปแบบเอาต์พุตที่ถูกต้อง 🔹**  
              ```plaintext
              ระดับความเสี่ยง: [ต่ำ/ปานกลาง/สูง]  
              โรคที่อาจเกิดขึ้น: [ชื่อโรค]  
              คำอธิบาย: [รายละเอียดเกี่ยวกับโรคที่เกิดจากน้ำท่วม]  
              การป้องกัน: [วิธีป้องกันไม่ให้ติดเชื้อจากน้ำท่วม]  
              การรักษาเบื้องต้น: [วิธีดูแลตัวเองเบื้องต้นหากติดเชื้อ]  
              คำแนะนำเพิ่มเติม: [ข้อควรระวังหรือการดูแลเพิ่มเติม]  
          ''',
          'sessionid': sessionId,
          'temperature': '0.3',
        },
      ).timeout(const Duration(seconds: 30));

      print('API Response Raw: ${utf8.decode(response.bodyBytes)}');
      return _parseResponse(response);
    } catch (e) {
      throw Exception('API Error: ${e.toString()}');
    }
  }

  static DiseaseAnalysis _parseResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return DiseaseAnalysis.fromRawString(decoded['response']);
    } else {
      throw Exception('Failed with status: ${response.statusCode}');
    }
  }
}
