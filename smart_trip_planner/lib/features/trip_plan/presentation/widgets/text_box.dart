import 'package:flutter/material.dart';

import 'package:smart_trip_planner/core/theme/app_color.dart';

class InputTextBox extends StatelessWidget {
  final TextEditingController controller;
  const InputTextBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGreadient2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: controller,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            maxLines: 4,
            decoration: InputDecoration(
              border: InputBorder.none, // Hide all borders
              enabledBorder: InputBorder.none, // Hide when not focused
              focusedBorder: InputBorder.none,
              hint: Text(
                "Start planing ...",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: AppColors.textLight),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 12),
            child: Icon(Icons.mic, size: 30, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }
}
