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
            กรุณาวิเคราะห์อาการและความเสี่ยงของโรคที่อาจเกิดจากน้ำท่วมจากข้อมูลที่ให้มา
            
            เงื่อนไขสำคัญ:  
            - วิเคราะห์ความเสี่ยงของโรคที่อาจเกิดจากน้ำท่วมจากอาการที่พบ
            - ให้คำแนะนำในการป้องกันและรักษาเบื้องต้น
            - ระบุระดับความรุนแรงของความเสี่ยง (ต่ำ, ปานกลาง, สูง)
            
            รูปแบบการตอบกลับ (**ต้องปฏิบัติตามโครงสร้างนี้ทุกประการ**):
            ระดับความเสี่ยง: [ต่ำ/ปานกลาง/สูง]
            โรคที่อาจเกิดขึ้น: [ชื่อโรค]
            คำอธิบาย: [คำอธิบายเกี่ยวกับโรคและความเสี่ยง]
            การป้องกัน: [วิธีการป้องกัน]
            การรักษาเบื้องต้น: [วิธีการรักษาเบื้องต้น]
            คำแนะนำเพิ่มเติม: [คำแนะนำเพิ่มเติม]
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