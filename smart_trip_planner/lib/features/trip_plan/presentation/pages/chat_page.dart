import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_state.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/chat_input_box.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelChatScreen extends StatefulWidget {
  final String initialPrompt;
  final ItineraryEntity initialResponse;

  const TravelChatScreen({
    super.key,
    required this.initialPrompt,
    required this.initialResponse,
  });

  @override
  State<TravelChatScreen> createState() => _TravelChatScreenState();
}

class _TravelChatScreenState extends State<TravelChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.addAll([
      ChatMessage(text: widget.initialPrompt, role: 'user'),
      ChatMessage(entity: widget.initialResponse, role: 'assistant'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItineraryBloc, ItineraryState>(
      listener: (context, state) {
        if (state is ItineraryLoaded) {
          setState(() {
            messages.add(
              ChatMessage(role: 'assistant', entity: state.itinerary),
            );
          });
        } else if (state is ItineraryError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '7 days in Bali...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const CircleAvatar(
                backgroundColor: AppColors.primaryDark,
                radius: 18,
                child: Text('S', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ItineraryBloc, ItineraryState>(
                builder: (context, state) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount:
                        messages.length + (state is ItineraryLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length &&
                          state is ItineraryLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Itinera AI is thinking..."),
                          ),
                        );
                      }
                      return _buildCenteredMessage(messages[index]);
                    },
                  );
                },
              ),
            ),
            ChatInputBox(
              messageController: _messageController,
              onSend: (text) {
                if (text.trim().isEmpty) return;
                setState(() {
                  messages.add(ChatMessage(text: text, role: 'user'));
                  _messageController.clear();
                });
                context.read<ItineraryBloc>().add(
                  RefineItineraryEvent(
                    history: messages,
                    userMessage: text,
                    previousJson: _getLastAssistantJson(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredMessage(ChatMessage message) {
    final isUser = message.role == 'user';
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isUser
                      ? AppColors.primaryDark
                      : Colors.orange,
                  radius: 16,
                  child: Text(
                    isUser ? 'S' : 'AI',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isUser ? 'You' : 'Itinera AI',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            message.entity != null
                ? _buildItineraryContent(message.entity!)
                : Text(
                    message.text ?? '',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
            if (message.entity != null) ...[
              const SizedBox(height: 16),
              BlocBuilder<ItineraryBloc, ItineraryState>(
                builder: (context, state) {
                  if (state is ItineraryLoaded) {
                    return _buildMapCard(state.itinerary);
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey, thickness: 0.5),
              _buildAssistantActions(
                onCopy: () {},
                onRegenerate: () {},
                onSaveOffline: () {},
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryContent(ItineraryEntity itinerary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itinerary.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "${_formatDate(itinerary.startDate)} → ${_formatDate(itinerary.endDate)}",
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(itinerary.days.length, (index) {
          final day = itinerary.days[index];
          final dayNumber = index + 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Day $dayNumber: ${day.summary}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                ...day.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "• "),
                          if (item.time.isNotEmpty)
                            TextSpan(
                              text: "${_formatTime(item.time)}: ",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          TextSpan(
                            text: item.activity,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatTime(String time24) {
    try {
      final parsed = DateFormat("HH:mm").parse(time24);
      return DateFormat("h:mm a").format(parsed); // like 2:30 PM
    } catch (_) {
      return time24;
    }
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("d MMMM yyyy").format(parsed); // like 2 January 2025
    } catch (_) {
      return date;
    }
  }

  Widget _buildMapCard(ItineraryEntity itinerary) {
    final firstLocation = itinerary.days.first.items.first.location;

    final parts = firstLocation.split(',');
    final hasLatLng = parts.length == 2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              if (hasLatLng) {
                final lat = parts[0].trim();
                final lng = parts[1].trim();
                final url =
                    'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              } else {
                // Fallback: search by location name
                final encoded = Uri.encodeComponent(firstLocation);
                final fallbackUrl =
                    'https://www.google.com/maps/search/?api=1&query=$encoded';
                await launchUrl(
                  Uri.parse(fallbackUrl),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: const Text(
              "📍 Open in maps",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Aurangabad to destination | ~11hrs 5mins",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantActions({
    required VoidCallback onCopy,
    required VoidCallback onSaveOffline,
    required VoidCallback onRegenerate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onCopy,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.copy, size: 16),
              label: const Text("Copy"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextButton.icon(
              onPressed: onSaveOffline,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.download, size: 16),
              label: const Text("Save"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextButton.icon(
              onPressed: onRegenerate,
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text("Regenerate"),
            ),
          ),
        ],
      ),
    );
  }

  String _getLastAssistantJson() {
    final reversed = messages.reversed;
    final assistantEntity = reversed.firstWhere(
      (msg) => msg.role == 'assistant' && msg.entity != null,
      orElse: () => ChatMessage(text: '{}', role: 'assistant'),
    );
    return jsonEncode(assistantEntity.entity?.toModel().toJson());
  }
}

class ChatMessage {
  final String? text;
  final String role; // 'user' or 'assistant'
  final ItineraryEntity? entity;

  ChatMessage({this.text, required this.role, this.entity});
}
