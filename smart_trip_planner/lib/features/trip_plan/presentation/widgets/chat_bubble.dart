import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';

class ItineraryDisplay extends StatelessWidget {
  final ItineraryEntity itinerary;
  final VoidCallback onRegenerate;

  const ItineraryDisplay({
    super.key,
    required this.itinerary,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatarHeader(isAssistant: true),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildItineraryContent(itinerary),
        ),
        const SizedBox(height: 16),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildAvatarHeader({required bool isAssistant}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: isAssistant ? Colors.orange : AppColors.primaryDark,
          radius: 18,
          child: isAssistant
              ? const Icon(Icons.message, color: Colors.white, size: 18)
              : const Text('U', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Text(
          isAssistant ? 'Itinera AI' : 'You',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (isAssistant) ...[
          const SizedBox(width: 8),
          const SizedBox(
            width: 8,
            height: 8,
            child: CircularProgressIndicator(strokeWidth: 1.8),
          ),
          const SizedBox(width: 4),
          const Text("Thinking...", style: TextStyle(fontSize: 13)),
        ],
      ],
    );
  }

  Widget _buildItineraryContent(ItineraryEntity itinerary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itinerary.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(_formatDateRange(itinerary.startDate, itinerary.endDate)),
        const SizedBox(height: 16),
        ...itinerary.days.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day ${index + 1}: ${day.summary}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...day.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "• ${_formatTime(item.time)}: ${item.activity} (📍 ${item.location})",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
      ],
    );
  }

  String _formatDateRange(String start, String end) {
    final startDate = DateTime.tryParse(start);
    final endDate = DateTime.tryParse(end);
    final formatter = DateFormat('d MMMM yyyy');
    if (startDate != null && endDate != null) {
      return "${formatter.format(startDate)} → ${formatter.format(endDate)}";
    }
    return "$start → $end";
  }

  String _formatTime(String time) {
    try {
      final t = DateFormat("HH:mm").parse(time);
      return DateFormat("h:mm a").format(t);
    } catch (_) {
      return time;
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: itinerary.title));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Copied!")));
          },
          icon: const Icon(Icons.copy, size: 18),
          label: const Text("Copy"),
        ),
        TextButton.icon(
          onPressed: () {
            context.read<ItineraryBloc>().add(
              SaveItineraryOfflineEvent(itinerary: itinerary),
            );
          },
          icon: const Icon(Icons.download_for_offline, size: 18),
          label: const Text("Save Offline"),
        ),
        TextButton.icon(
          onPressed: onRegenerate,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text("Regenerate"),
        ),
      ],
    );
  }
}
