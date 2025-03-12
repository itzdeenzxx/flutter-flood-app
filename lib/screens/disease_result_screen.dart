import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/disease_analysis.dart';

class DiseaseResultScreen extends StatelessWidget {
  final DiseaseAnalysis analysis;

  const DiseaseResultScreen({
    Key? key,
    required this.analysis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color riskColor;
    IconData riskIcon;

    switch (analysis.riskLevel.toLowerCase()) {
      case 'สูง':
        riskColor = Colors.red;
        riskIcon = Icons.warning_rounded;
        break;
      case 'ปานกลาง':
        riskColor = Colors.orange;
        riskIcon = Icons.report_problem_rounded;
        break;
      default:
        riskColor = Colors.green;
        riskIcon = Icons.check_circle_rounded;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ผลการวิเคราะห์'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRiskLevelSection(context, riskColor, riskIcon),
              const SizedBox(height: 24),
              _buildInfoBlock(
                context,
                'โรคที่อาจเกิดขึ้น',
                analysis.possibleDisease,
                Icons.coronavirus_rounded,
                Colors.red.shade100,
              ),
              _buildInfoBlock(
                context,
                'คำอธิบาย',
                analysis.description,
                Icons.info_outline,
                Colors.blue.shade100,
              ),
              _buildInfoBlock(
                context,
                'การป้องกัน',
                analysis.prevention,
                Icons.shield_outlined,
                Colors.green.shade100,
              ),
              _buildInfoBlock(
                context,
                'การรักษาเบื้องต้น',
                analysis.firstAid,
                Icons.medical_services_outlined,
                Colors.amber.shade100,
              ),
              _buildInfoBlock(
                context,
                'คำแนะนำเพิ่มเติม',
                analysis.additionalAdvice,
                Icons.tips_and_updates_outlined,
                Colors.purple.shade100,
              ),
              const SizedBox(height: 16),
              if (analysis.riskLevel.toLowerCase() == 'สูง')
                _buildEmergencyContactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskLevelSection(BuildContext context, Color color, IconData icon) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 48),
        const SizedBox(height: 16),
        Text(
          'ระดับความเสี่ยง: ${analysis.riskLevel}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (analysis.riskLevel.toLowerCase() == 'สูง')
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              'โปรดติดต่อแพทย์หรือหน่วยฉุกเฉินโดยเร็วที่สุด',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    ),
  );
}


  Widget _buildInfoBlock(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color backgroundColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: backgroundColor.withOpacity(1.0)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactSection(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200)),
          child: Column(
            children: [
              const Text(
                'หากมีอาการรุนแรง โปรดติดต่อหน่วยฉุกเฉินทันที',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.phone, size: 24),
                      label: const Text('1669\nเหตุด่วนเหตุร้าย'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _callEmergency(context, '1669'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.emergency, size: 24),
                      label: const Text('1784\nภัยพิบัติ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _callEmergency(context, '1784'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _callEmergency(BuildContext context, String number) async {
    final Uri telUri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        throw 'Could not launch $telUri';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่สามารถโทรออก: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareResult(BuildContext context) {
    final String shareText = 
      'ผลการวิเคราะห์โรคจากน้ำท่วม\n'
      'ระดับความเสี่ยง: ${analysis.riskLevel}\n'
      'โรคที่อาจเกิดขึ้น: ${analysis.possibleDisease}\n'
      'คำอธิบาย: ${analysis.description}\n'
      'การป้องกัน: ${analysis.prevention}\n'
      'การรักษาเบื้องต้น: ${analysis.firstAid}\n\n'
      'แอปพลิเคชันรอดชีวิตจากน้ำท่วม';

    Share.share(
      shareText,
      subject: 'ผลการวิเคราะห์สุขภาพจากน้ำท่วม',
    );
  }
}