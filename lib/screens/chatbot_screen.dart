import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/flood_chatbot_service.dart';
import '../models/flood_message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<FloodMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _sessionId = const Uuid().v4();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'สวัสดีค่ะ ฉันคือแอลลี่ ผู้เชี่ยวชาญด้านน้ำท่วม 🌊\nฉันสามารถช่วยคุณตอบคำถามเกี่ยวกับน้ำท่วม การเตรียมพร้อม การป้องกัน และการดูแลสุขภาพในช่วงน้ำท่วมได้ คุณอยากทราบเรื่องใดเกี่ยวกับน้ำท่วมคะ?'
    );
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(FloodMessage(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(FloodMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await FloodChatbotService.getChatbotResponse(
        userMessage: text,
        sessionId: _sessionId,
      );

      setState(() {
        _isTyping = false;
        _messages.add(FloodMessage(text: response, isUser: false));
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(FloodMessage(
          text: 'ขออภัยค่ะ เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง',
          isUser: false,
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แอลลี่ - ผู้เชี่ยวชาญด้านน้ำท่วม',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                image: DecorationImage(
                  image: AssetImage('assets/images/water_bg.jpg'),
                  opacity: 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.white,
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1E88E5),
                    radius: 16.0,
                    child: Text(
                      'อ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text('กำลังพิมพ์...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'พิมพ์คำถามเกี่ยวกับน้ำท่วม...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: () => _handleSubmitted(_textController.text),
                    backgroundColor: const Color(0xFF1E88E5),
                    elevation: 2.0,
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(FloodMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: const Color(0xFF1E88E5),
              radius: 16.0,
              child: const Text(
                'อ',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
            ),
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF1E88E5) : Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    message.formattedTime,
                    style: TextStyle(
                      color: message.isUser ? Colors.white70 : Colors.black45,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8.0),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 16.0,
              child: const Icon(
                Icons.person,
                size: 18.0,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.water_drop, color: Color(0xFF1E88E5)),
            SizedBox(width: 8.0),
            Text('เกี่ยวกับแอลลี่'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'แอลลี่เป็นแชทบอทที่ออกแบบมาเพื่อให้ความช่วยเหลือและข้อมูลเกี่ยวกับน้ำท่วม คุณสามารถถามคำถามเกี่ยวกับ:',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 12.0),
            Text('• สาเหตุของน้ำท่วม', style: TextStyle(fontSize: 14.0)),
            Text('• การเตรียมพร้อมรับมือน้ำท่วม', style: TextStyle(fontSize: 14.0)),
            Text('• การปฐมพยาบาลและดูแลสุขภาพในช่วงน้ำท่วม', style: TextStyle(fontSize: 14.0)),
            Text('• ข้อควรระวังในช่วงน้ำท่วม', style: TextStyle(fontSize: 14.0)),
            Text('• วิธีการอพยพเมื่อเกิดน้ำท่วม', style: TextStyle(fontSize: 14.0)),
            Text('• คำแนะนำในการทำความสะอาดบ้านหลังน้ำท่วม', style: TextStyle(fontSize: 14.0)),
            Text('• โรคที่มักเกิดในช่วงน้ำท่วม', style: TextStyle(fontSize: 14.0)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('เข้าใจแล้ว', style: TextStyle(color: Color(0xFF1E88E5))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}