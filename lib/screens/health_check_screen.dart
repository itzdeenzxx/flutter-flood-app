import 'package:flutter/material.dart';
import 'package:flood_survival_app/models/health_check.dart';
import 'package:flood_survival_app/widgets/bottom_navigation.dart';

class HealthCheckScreen extends StatefulWidget {
  const HealthCheckScreen({Key? key}) : super(key: key);

  @override
  State<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends State<HealthCheckScreen> {
  bool _hasFever = false;
  bool _hasCough = false;
  bool _hasSkinRash = false;
  bool _hasDiarrhea = false;
  bool _hasWaterContamination = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจสุขภาพ'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ส่วนหัวของหน้า
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // รายการตรวจสอบอาการ
              _buildSymptomChecklist(),
              
              const SizedBox(height: 24),
              
              // ช่องสำหรับบันทึกเพิ่มเติม
              _buildNotesSection(),
              
              const SizedBox(height: 32),
              
              // ปุ่มบันทึกผลตรวจสุขภาพ
              _buildSaveButton(),
              
              const SizedBox(height: 24),
              
              // คำแนะนำสุขภาพทั่วไป
              _buildHealthTips(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ตรวจสุขภาพประจำวัน',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'บันทึกอาการของคุณเพื่อติดตามสุขภาพในช่วงน้ำท่วม',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700]),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'การตรวจสุขภาพอย่างสม่ำเสมอช่วยป้องกันโรคที่มากับน้ำท่วมได้',
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

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'บันทึกเพิ่มเติม',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'บันทึกอาการหรือข้อสังเกตเพิ่มเติม...',
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveHealthCheck,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'บันทึกผลตรวจสุขภาพ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHealthTips() {
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
              'คำแนะนำสุขภาพช่วงน้ำท่วม',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              Icons.water_drop,
              'ดื่มน้ำสะอาดเท่านั้น',
              'ใช้น้ำต้มสุกหรือน้ำบรรจุขวดที่ปิดสนิท',
            ),
            _buildTipItem(
              Icons.sanitizer,
              'ล้างมือบ่อยๆ',
              'ล้างมือด้วยสบู่และน้ำสะอาดหรือเจลแอลกอฮอล์',
            ),
            _buildTipItem(
              Icons.healing,
              'ดูแลบาดแผล',
              'ทำความสะอาดและปิดแผลทันทีหากมีบาดแผลเปิด',
            ),
            _buildTipItem(
              Icons.health_and_safety,
              'ใส่รองเท้าบูท',
              'ป้องกันการสัมผัสน้ำโดยตรงเพื่อลดความเสี่ยงโรคผิวหนัง',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveHealthCheck() {
    // สร้างข้อมูลตรวจสุขภาพใหม่
    final healthCheck = HealthCheck(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      hasFever: _hasFever,
      hasCough: _hasCough,
      hasSkinRash: _hasSkinRash,
      hasDiarrhea: _hasDiarrhea,
      hasWaterContamination: _hasWaterContamination,
      additionalNotes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    // TODO: บันทึกข้อมูลลงฐานข้อมูลหรือใน SharedPreferences

    // คำนวณระดับความเสี่ยง
    final riskLevel = healthCheck.getRiskLevel();
    
    // แสดงข้อความแจ้งผลการบันทึก
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกข้อมูลสำเร็จ ระดับความเสี่ยง: $riskLevel'),
        backgroundColor: riskLevel == 'สูง'
            ? Colors.red
            : riskLevel == 'ปานกลาง'
                ? Colors.orange
                : Colors.green,
      ),
    );

    // แสดงข้อความแนะนำตามระดับความเสี่ยง
    if (riskLevel == 'สูง') {
      _showRiskAlert();
    }
  }

  void _showRiskAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('คำเตือน: ความเสี่ยงสูง'),
        content: const Text(
          'คุณมีความเสี่ยงสูงต่อการเกิดโรคที่มากับน้ำท่วม โปรดพบแพทย์โดยเร็วที่สุด',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('เข้าใจแล้ว'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: นำทางไปยังหน้าติดต่อฉุกเฉิน
            },
            child: const Text('ติดต่อฉุกเฉิน'),
          ),
        ],
      ),
    );
  }
}