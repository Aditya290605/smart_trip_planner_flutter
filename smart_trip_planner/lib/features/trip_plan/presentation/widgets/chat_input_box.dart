import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';

class ChatInputBox extends StatelessWidget {
  final TextEditingController messageController;
  final void Function(String)? onSend;

  const ChatInputBox({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Input + mic in one rounded border
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Follow up to refine',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onSubmitted: onSend,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onSend?.call(messageController.text),
                    icon: Icon(Icons.mic, color: Colors.grey[700], size: 22),
                    tooltip: "Speak",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Send button separately styled
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => onSend?.call(messageController.text),
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              tooltip: "Send",
            ),
          ),
        ],
      ),
    );
  }
}
