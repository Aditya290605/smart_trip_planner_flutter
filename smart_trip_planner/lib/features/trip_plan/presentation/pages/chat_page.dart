import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/chat_input_box.dart';

class TravelChatScreen extends StatefulWidget {
  const TravelChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TravelChatScreenState createState() => _TravelChatScreenState();
}

class _TravelChatScreenState extends State<TravelChatScreen> {
  List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with the conversation from the image
    messages = [
      ChatMessage(
        text:
            '7 days in Bali next April, 3 people, mid-range budget, wanted to explore less populated areas, it should be a peaceful trip!',
        isUser: true,
      ),
      ChatMessage(
        text: '''Day 1: Arrival in Bali & Settle in Ubud
• Morning: Arrive in Bali, Denpasar Airport.
• Transfer: Private driver to Ubud (around 1.5 hours).
• Accommodation: Check-in at a peaceful boutique hotel or villa in Ubud (e.g., Ubud Aura Retreat or Komaneeka at Bisma).
• Afternoon: Explore Ubud's local area, walk around the tranquil rice terraces at Tegallalang.
• Evening: Dinner at Locavore (known for farm-to-table dishes in a peaceful setting).''',
        isUser: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '7 days in Bali...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              radius: 18,
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          ChatInputBox(
            messageController: _messageController,
            onSend: (String text) {
              if (text.trim().isEmpty) return;

              setState(() {
                messages.add(ChatMessage(text: text, isUser: true));
                _messageController.clear();
              });

              // Simulate AI response
              Future.delayed(Duration(milliseconds: 800), () {
                setState(() {
                  messages.add(
                    ChatMessage(
                      text:
                          "I'd be happy to help you refine your Bali itinerary! Could you tell me more about what specific aspects you'd like to adjust? For example, are you looking to modify activities, accommodation preferences, or perhaps add more cultural experiences?",
                      isUser: false,
                    ),
                  );
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: message.isUser
                ? AppColors.primaryDark
                : Colors.orange,
            radius: 18,
            child: Text(
              message.isUser ? 'S' : 'AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isUser ? 'You' : 'Itinera AI',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      if (!message.isUser) ...[
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Open in maps functionality
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Open in maps',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Mumbai to Bali, Indonesia • 11hrs 5mins',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!message.isUser) ...[
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActionButton(Icons.content_copy, 'Copy'),
                      SizedBox(width: 24),
                      _buildActionButton(Icons.download, 'Save Offline'),
                      SizedBox(width: 24),
                      _buildActionButton(Icons.refresh, 'Regenerate'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Handle action
      },
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
