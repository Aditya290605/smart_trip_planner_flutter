import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';

class ItineriesCard extends StatelessWidget {
  final String title;
  const ItineriesCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ), // spacing between cards
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(46),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // Dot
            Container(
              margin: const EdgeInsets.only(right: 12),
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
            // Title
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
