import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';

class ChatInputBox extends StatelessWidget {
  final TextEditingController messageController;
  final Function(String) onSend;

  const ChatInputBox({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        20,
      ), // left, top, right, bottom
      child: Row(
        children: [
          // Input box with mic icon
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryDark),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Follow up to refine',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: AppColors.primaryDark),
                    onPressed: () {
                      // Add STT logic later if needed
                    },
                    tooltip: "Voice Input",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Send button
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                onSend(messageController.text);
              },
              tooltip: "Send",
            ),
          ),
        ],
      ),
    );
  }
}
