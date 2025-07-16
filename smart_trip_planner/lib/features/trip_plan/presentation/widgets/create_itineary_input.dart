import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';

class StyledInputBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onMicTap;

  const StyledInputBox({super.key, required this.controller, this.onMicTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryDark),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: "Type somthing .....",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Mic icon inside the input
          IconButton(
            icon: Icon(Icons.mic, color: AppColors.primaryDark),
            onPressed: onMicTap,
            tooltip: "Voice Input",
          ),
        ],
      ),
    );
  }
}
