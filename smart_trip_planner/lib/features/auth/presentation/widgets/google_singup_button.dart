import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';

class GoogleSingupButton extends StatelessWidget {
  final String text;
  const GoogleSingupButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/g-logo-2.png', height: 25, width: 25),
          const SizedBox(width: 20),
          Text(text, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
