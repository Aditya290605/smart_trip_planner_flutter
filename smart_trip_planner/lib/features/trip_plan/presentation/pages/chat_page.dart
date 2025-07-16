import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/core/utils/userdata.dart';
import 'package:smart_trip_planner/features/trip_plan/data/repository/tokens_limit.dart';

import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_state.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/ai_loading.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/chat_input_box.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/error_card.dart';
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
    final userInitial = context.watch<UserProvider>().userName;

    return BlocListener<ItineraryBloc, ItineraryState>(
      listener: (context, state) {
        if (state is ItineraryLoaded) {
          GeminiUsageTracker().track(
            prompt: widget.initialPrompt,
            response: state.itinerary.toString(),
          );

          setState(() {
            messages.add(
              ChatMessage(role: 'assistant', entity: state.itinerary),
            );
          });
        } else if (state is ItineraryError) {
          ErrorCard(
            message: state.message,
            isChat: false,
            onRetry: () {
              context.read<ItineraryBloc>().add(
                RefineItineraryEvent(
                  history: messages,
                  userMessage: messages.last.text!,
                  previousJson: _getLastAssistantJson(),
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.initialPrompt,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryDark,
                radius: 18,
                child: Text(
                  userInitial.isNotEmpty ? userInitial[0].toUpperCase() : '?',
                  style: TextStyle(color: Colors.white),
                ),
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
                        return const AiLoading();
                      }
                      ItineraryEntity? latestItineray;

                      if (state is ItineraryLoaded) {
                        latestItineray = state.itinerary;
                      }

                      // Defensive: If latestItineray is null, show a placeholder
                      if (index >= messages.length) {
                        return const SizedBox.shrink();
                      }

                      final msg = messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _buildCenteredMessage(
                          msg,
                          userInitial.isNotEmpty
                              ? userInitial[0].toUpperCase()
                              : '?',
                          msg.entity ??
                              ItineraryEntity(
                                title: '',
                                startDate: '',
                                endDate: '',
                                days: [],
                              ),
                        ),
                      );
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

  Widget _buildCenteredMessage(
    ChatMessage message,
    String userInitial,
    ItineraryEntity entity,
  ) {
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
              color: const Color.fromARGB(255, 214, 213, 213),
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
                  child: isUser
                      ? Text(
                          userInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(size: 18, Icons.chat_sharp),
                ),
                const SizedBox(width: 10),
                Text(
                  isUser ? 'You' : 'Itinera AI',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            message.entity != null && entity.days.isNotEmpty
                ? _buildItineraryContent(entity)
                : Text(
                    message.text ?? 'No itinerary data.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
            if (message.entity != null && entity.days.isNotEmpty) ...[
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
                onSaveOffline: () {
                  context.read<ItineraryBloc>().add(
                    SaveItineraryOfflineEvent(itinerary: entity),
                  );
                },
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
            onTap: () {
              final loc = itinerary.days.first.items.first.location;
              final mapUrl =
                  'https://www.google.com/maps/search/?api=1&query=$loc';
              launchUrl(Uri.parse(mapUrl));
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onCopy,
              style: TextButton.styleFrom(
                iconColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.copy, size: 16),
              label: Text(
                "Copy",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          Expanded(
            child: TextButton.icon(
              onPressed: onSaveOffline,
              style: TextButton.styleFrom(
                iconColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.download, size: 16),
              label: Text(
                "Save",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          Expanded(
            child: TextButton.icon(
              onPressed: onRegenerate,
              style: TextButton.styleFrom(
                iconColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(
                "Regenerate",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
