import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flood_survival_app/models/emergency_contact.dart';
import 'package:flood_survival_app/widgets/bottom_navigation.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  String _filterCategory = 'ทั้งหมด';
  final List<String> _categories = ['ทั้งหมด', 'หน่วยงานรัฐ', 'การแพทย์', 'ส่วนตัว'];

  // Firestore stream to fetch contacts for the authenticated user.
  Stream<QuerySnapshot<Map<String, dynamic>>> _contactsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('emergencyContacts')
          .snapshots();
    } else {
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ติดต่อฉุกเฉิน'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddContactDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          _buildEmergencyCallsSection(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _contactsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('ไม่พบรายชื่อติดต่อ'));
                }
                final contacts = snapshot.data!.docs.map((doc) {
                  final data = doc.data();
                  return EmergencyContact.fromJson(data);
                }).toList();

                // Filter contacts based on category.
                List<EmergencyContact> filteredContacts = _filterCategory == 'ทั้งหมด'
                    ? contacts
                    : contacts.where((contact) => contact.category == _filterCategory).toList();

                // Split favorites and others.
                List<EmergencyContact> favoriteContacts =
                    filteredContacts.where((contact) => contact.isFavorite).toList();
                List<EmergencyContact> otherContacts =
                    filteredContacts.where((contact) => !contact.isFavorite).toList();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (favoriteContacts.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'รายการโปรด',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...favoriteContacts.map((contact) => _buildContactCard(contact)),
                      const SizedBox(height: 16),
                    ],
                    if (otherContacts.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'รายชื่อติดต่อ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...otherContacts.map((contact) => _buildContactCard(contact)),
                    ],
                    if (filteredContacts.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'ไม่พบรายชื่อติดต่อในหมวดหมู่นี้',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return FilterChip(
            label: Text(category),
            selected: _filterCategory == category,
            onSelected: (selected) {
              setState(() {
                _filterCategory = category;
              });
            },
            backgroundColor: Colors.grey[100],
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            checkmarkColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: _filterCategory == category
                  ? Theme.of(context).primaryColor
                  : Colors.grey[800],
              fontWeight: _filterCategory == category ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyCallsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'เบอร์โทรฉุกเฉิน',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEmergencyButton('191', 'ตำรวจ'),
              _buildEmergencyButton('1669', 'รถพยาบาล'),
              _buildEmergencyButton('199', 'ดับเพลิง'),
              _buildEmergencyButton('1784', 'น้ำท่วม'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(String phoneNumber, String label) {
    return InkWell(
      onTap: () => _callPhoneNumber(phoneNumber),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              Icons.call,
              color: Colors.red[700],
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            phoneNumber,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(EmergencyContact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (contact.isFavorite)
                        Icon(
                          Icons.star,
                          color: Colors.amber[700],
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.phoneNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  if (contact.notes != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      contact.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.call),
              color: Colors.green,
              onPressed: () => _callPhoneNumber(contact.phoneNumber),
            ),
            IconButton(
              icon: Icon(
                contact.isFavorite ? Icons.star : Icons.star_border,
                color: contact.isFavorite ? Colors.amber[700] : Colors.grey,
              ),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('emergencyContacts')
                      .doc(contact.id)
                      .update({'isFavorite': !contact.isFavorite});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await url_launcher.canLaunchUrl(phoneUri)) {
      await url_launcher.launchUrl(phoneUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่สามารถโทรออกไปที่เบอร์ $phoneNumber ได้'),
          ),
        );
      }
    }
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final notesController = TextEditingController();
    String selectedCategory = 'หน่วยงานรัฐ';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เพิ่มรายชื่อติดต่อ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                  icon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  icon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'หมวดหมู่',
                  icon: Icon(Icons.category),
                ),
                items: ['หน่วยงานรัฐ', 'การแพทย์', 'ส่วนตัว']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'บันทึกเพิ่มเติม (ไม่บังคับ)',
                  icon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty &&
                  phoneController.text.trim().isNotEmpty) {
                final newContact = EmergencyContact(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  category: selectedCategory,
                  notes: notesController.text.trim().isNotEmpty
                      ? notesController.text.trim()
                      : null,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('emergencyContacts')
                      .doc(newContact.id)
                      .set(newContact.toJson());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('เพิ่มรายชื่อติดต่อสำเร็จ')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('กรุณากรอกชื่อและเบอร์โทรศัพท์'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }
}
