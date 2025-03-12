import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // ต้องติดตั้ง uuid package
import '../services/disease_analysis_service.dart';
import '../screens/disease_result_screen.dart';
import '../widgets/bottom_navigation.dart';

class DiseaseAnalyzerScreen extends StatefulWidget {
  const DiseaseAnalyzerScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseAnalyzerScreen> createState() => _DiseaseAnalyzerScreenState();
}

class _DiseaseAnalyzerScreenState extends State<DiseaseAnalyzerScreen> {
  bool _hasFever = false;
  bool _hasCough = false;
  bool _hasSkinRash = false;
  bool _hasDiarrhea = false;
  bool _hasWaterContamination = false;
  bool _hasHeadache = false;
  bool _hasMusclePain = false;
  bool _hasDifficultBreathing = false;
  
  final TextEditingController _additionalSymptomsController = TextEditingController();
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('วิเคราะห์โรคจากน้ำท่วม'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              _buildSymptomChecklist(),
              
              const SizedBox(height: 24),
              
              _buildAdditionalSymptoms(),
              
              const SizedBox(height: 32),
              
              _buildAnalyzeButton(),
              
              const SizedBox(height: 24),
              
              _buildInfoSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'วิเคราะห์ความเสี่ยงโรคจากน้ำท่วม',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'เลือกอาการที่คุณพบเพื่อรับการวิเคราะห์ความเสี่ยงโรคที่อาจเกิดจากน้ำท่วม',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber[700]),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'ข้อมูลนี้เป็นเพียงการวิเคราะห์เบื้องต้น ไม่สามารถใช้แทนการวินิจฉัยจากแพทย์ได้',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomChecklist() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'อาการที่พบ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCheckItem(
              'มีไข้',
              'อุณหภูมิร่างกายสูงกว่าปกติ',
              _hasFever,
              (value) {
                setState(() {
                  _hasFever = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'ไอ',
              'ไอแห้งหรือมีเสมหะ',
              _hasCough,
              (value) {
                setState(() {
                  _hasCough = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'ผื่นที่ผิวหนัง',
              'มีผื่นแดง คัน หรือตุ่มน้ำที่ผิว',
              _hasSkinRash,
              (value) {
                setState(() {
                  _hasSkinRash = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'ท้องเสีย',
              'ถ่ายเหลวมากกว่า 3 ครั้งต่อวัน',
              _hasDiarrhea,
              (value) {
                setState(() {
                  _hasDiarrhea = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'ปวดศีรษะ',
              'ปวดรุนแรงหรือต่อเนื่อง',
              _hasHeadache,
              (value) {
                setState(() {
                  _hasHeadache = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'ปวดเมื่อยกล้ามเนื้อ',
              'รู้สึกปวดเมื่อยตามร่างกาย',
              _hasMusclePain,
              (value) {
                setState(() {
                  _hasMusclePain = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'หายใจลำบาก',
              'รู้สึกเหนื่อยหรือหายใจไม่สะดวก',
              _hasDifficultBreathing,
              (value) {
                setState(() {
                  _hasDifficultBreathing = value ?? false;
                });
              },
            ),
            _buildCheckItem(
              'สัมผัสน้ำปนเปื้อน',
              'สัมผัสน้ำท่วมที่อาจมีการปนเปื้อน',
              _hasWaterContamination,
              (value) {
                setState(() {
                  _hasWaterContamination = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(
    String title,
    String subtitle,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'อาการอื่นๆ (ถ้ามี)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _additionalSymptomsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'ระบุอาการอื่นๆ ที่พบ เช่น มีบวมตามร่างกาย เวียนศีรษะ คลื่นไส้...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _analyzeDisease,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'วิเคราะห์ความเสี่ยง',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ระบบวิเคราะห์โรคจากน้ำท่วม',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ระบบนี้ใช้ AI วิเคราะห์ความเสี่ยงของโรคที่อาจเกิดจากน้ำท่วมจากอาการที่คุณระบุ ผลวิเคราะห์ที่ได้เป็นเพียงข้อมูลเบื้องต้น ไม่สามารถใช้แทนการวินิจฉัยจากแพทย์ผู้เชี่ยวชาญได้',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'หากมีอาการรุนแรงหรือเป็นอันตราย โปรดติดต่อแพทย์หรือหน่วยฉุกเฉินทันที',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _analyzeDisease() async {
    // ตรวจสอบว่ามีการเลือกอาการอย่างน้อย 1 อย่าง
    if (!_hasFever && !_hasCough && !_hasSkinRash && !_hasDiarrhea && 
        !_hasWaterContamination && !_hasHeadache && !_hasMusclePain && 
        !_hasDifficultBreathing && _additionalSymptomsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเลือกอาการอย่างน้อย 1 อย่าง'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // สร้างข้อความสำหรับส่งไปยัง API
    List<String> symptoms = [];
    if (_hasFever) symptoms.add('มีไข้');
    if (_hasCough) symptoms.add('ไอ');
    if (_hasSkinRash) symptoms.add('มีผื่นที่ผิวหนัง');
    if (_hasDiarrhea) symptoms.add('ท้องเสีย');
    if (_hasHeadache) symptoms.add('ปวดศีรษะ');
    if (_hasMusclePain) symptoms.add('ปวดเมื่อยกล้ามเนื้อ');
    if (_hasDifficultBreathing) symptoms.add('หายใจลำบาก');
    if (_hasWaterContamination) symptoms.add('สัมผัสน้ำที่ปนเปื้อน');

    // เพิ่มอาการอื่นๆ จากช่อง input
    if (_additionalSymptomsController.text.trim().isNotEmpty) {
      symptoms.add('อาการอื่นๆ: ${_additionalSymptomsController.text.trim()}');
    }

    // สร้างข้อความสำหรับส่งไปยัง API
    final symptomsText = '''
อาการที่พบในผู้ป่วยในพื้นที่ประสบอุทกภัย:
${symptoms.map((s) => '- $s').join('\n')}
''';

    // แสดง loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // สร้าง session ID สำหรับการเรียก API
      final sessionId = const Uuid().v4();
      
      // เรียกใช้ API
      final result = await DiseaseAnalysisService.analyzeDiseaseRisk(
        symptoms: symptomsText,
        sessionId: sessionId,
      );
      
      // ซ่อน loading indicator
      setState(() {
        _isLoading = false;
      });
      
      // นำทางไปยังหน้าแสดงผล
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiseaseResultScreen(analysis: result),
        ),
      );
    } catch (e) {
      // ซ่อน loading indicator
      setState(() {
        _isLoading = false;
      });
      
      // แสดงข้อความแจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}