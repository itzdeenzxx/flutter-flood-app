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
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  String _filterCategory = 'ทั้งหมด';
  final List<String> _categories = [
    'ทั้งหมด',
    'หน่วยงานรัฐ',
    'การแพทย์',
    'ส่วนตัว'
  ];

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
                  return EmergencyContact.fromJson({...data, 'id': doc.id});
                }).toList();

                // Filter contacts based on category.
                List<EmergencyContact> filteredContacts = _filterCategory ==
                        'ทั้งหมด'
                    ? contacts
                    : contacts
                        .where((contact) => contact.category == _filterCategory)
                        .toList();

                // Split favorites and others.
                List<EmergencyContact> favoriteContacts = filteredContacts
                    .where((contact) => contact.isFavorite)
                    .toList();
                List<EmergencyContact> otherContacts = filteredContacts
                    .where((contact) => !contact.isFavorite)
                    .toList();

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
                      ...favoriteContacts
                          .map((contact) => _buildContactCard(contact)),
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
                      ...otherContacts
                          .map((contact) => _buildContactCard(contact)),
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
              fontWeight: _filterCategory == category
                  ? FontWeight.bold
                  : FontWeight.normal,
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
      child: InkWell(
        onTap: () {
          _navigateToContactDetails(contact);
        },
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
                    if (contact.notes != null && contact.notes!.isNotEmpty) ...[
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
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('emergencyContacts')
                          .doc(contact.id)
                          .update({'isFavorite': !contact.isFavorite});

                      // แสดง Snackbar หลังจากเปลี่ยนสถานะ favorite
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              contact.isFavorite
                                  ? 'นำออกจากรายการโปรดแล้ว'
                                  : 'เพิ่มในรายการโปรดแล้ว',
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('เกิดข้อผิดพลาด: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToContactDetails(EmergencyContact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailScreen(
          contact: contact,
          onDelete: _deleteContact,
          onEdit: _showAddContactDialog,
        ),
      ),
    );
  }

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await url_launcher.canLaunchUrl(phoneUri)) {
        await url_launcher.launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ไม่สามารถโทรออกไปที่เบอร์ $phoneNumber ได้'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddContactDialog({EmergencyContact? contact}) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController =
        TextEditingController(text: contact?.phoneNumber ?? '');
    final notesController = TextEditingController(text: contact?.notes ?? '');
    String selectedCategory = contact?.category ?? 'หน่วยงานรัฐ';
    final bool isEditing = contact != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'แก้ไขรายชื่อติดต่อ' : 'เพิ่มรายชื่อติดต่อ'),
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
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    if (isEditing) {
                      // Update existing contact
                      final updatedContact = EmergencyContact(
                        id: contact!.id,
                        name: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        category: selectedCategory,
                        notes: notesController.text.trim().isNotEmpty
                            ? notesController.text.trim()
                            : null,
                        isFavorite: contact.isFavorite,
                      );
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('emergencyContacts')
                          .doc(contact.id)
                          .update(updatedContact.toJson());

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('แก้ไขรายชื่อติดต่อสำเร็จ'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    } else {
                      // Add new contact
                      final docRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('emergencyContacts')
                          .doc(); // สร้าง id ใหม่อัตโนมัติ

                      final newContact = EmergencyContact(
                        id: docRef.id,
                        name: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        category: selectedCategory,
                        notes: notesController.text.trim().isNotEmpty
                            ? notesController.text.trim()
                            : null,
                        isFavorite: false,
                      );

                      await docRef.set(newContact.toJson());

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('เพิ่มรายชื่อติดต่อสำเร็จ'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('เกิดข้อผิดพลาด: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
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
            child: Text(isEditing ? 'บันทึกการแก้ไข' : 'บันทึก'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteContact(EmergencyContact contact) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('emergencyContacts')
            .doc(contact.id)
            .delete();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('ลบรายชื่อติดต่อสำเร็จ'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class ContactDetailScreen extends StatefulWidget {
  final EmergencyContact contact;
  final Function(EmergencyContact) onDelete;
  final Function({EmergencyContact contact}) onEdit;

  const ContactDetailScreen({
    Key? key,
    required this.contact,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late EmergencyContact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดผู้ติดต่อ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditContactDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _contact.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _contact.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'ข้อมูลติดต่อ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DetailItem(
                      icon: Icons.phone,
                      title: 'เบอร์โทรศัพท์',
                      value: _contact.phoneNumber,
                      onTap: () {
                        _callPhoneNumber(_contact.phoneNumber);
                      },
                      actionIcon: Icons.call,
                      actionColor: Colors.green,
                    ),
                    if (_contact.notes != null &&
                        _contact.notes!.isNotEmpty) ...[
                      const Divider(height: 32),
                      DetailItem(
                        icon: Icons.note,
                        title: 'บันทึกเพิ่มเติม',
                        value: _contact.notes!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.call),
                label: const Text('โทรออก'),
                onPressed: () {
                  _callPhoneNumber(_contact.phoneNumber);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: Icon(
                  _contact.isFavorite ? Icons.star : Icons.star_border,
                  color: _contact.isFavorite ? Colors.amber[700] : null,
                ),
                label: Text(
                  _contact.isFavorite
                      ? 'เอาออกจากรายการโปรด'
                      : 'เพิ่มในรายการโปรด',
                ),
                onPressed: () {
                  _toggleFavorite();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditContactDialog() {
    widget.onEdit(contact: _contact);
    // อัพเดทข้อมูลหลังจากแก้ไข
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('emergencyContacts')
        .doc(_contact.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        setState(() {
          _contact = EmergencyContact.fromJson({
            ...snapshot.data()!,
            'id': snapshot.id,
          });
        });
      }
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content:
            Text('คุณต้องการลบรายชื่อติดต่อ "${_contact.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // ปิด dialog
              final success = await widget.onDelete(_contact);
              if (success == true && context.mounted) {
                Navigator.pop(context); // กลับไปหน้าหลัก
              }
            },
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final newFavoriteStatus = !_contact.isFavorite;

        // อัพเดทใน Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('emergencyContacts')
            .doc(_contact.id)
            .update({'isFavorite': newFavoriteStatus});

        // อัพเดทสถานะใน UI
        setState(() {
          _contact = EmergencyContact(
            id: _contact.id,
            name: _contact.name,
            phoneNumber: _contact.phoneNumber,
            category: _contact.category,
            notes: _contact.notes,
            isFavorite: newFavoriteStatus,
          );
        });

        // แสดง Snackbar แจ้งเตือน
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newFavoriteStatus
                    ? 'เพิ่มในรายการโปรดแล้ว'
                    : 'นำออกจากรายการโปรดแล้ว',
              ),
              backgroundColor: Theme.of(context).primaryColor,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'ตกลง',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await url_launcher.canLaunchUrl(phoneUri)) {
        await url_launcher.launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ไม่สามารถโทรออกไปที่เบอร์ $phoneNumber ได้'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final IconData? actionIcon;
  final Color? actionColor;

  const DetailItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.actionIcon,
    this.actionColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        if (onTap != null && actionIcon != null)
          IconButton(
            icon: Icon(actionIcon),
            color: actionColor,
            onPressed: onTap,
          ),
      ],
    );
  }
}
