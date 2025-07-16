import 'package:flutter/material.dart';
import 'package:smart_trip_planner/features/trip_plan/data/tts_stt_service.dart';

class ChatInputBox extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String) onSend;
  const ChatInputBox({
    Key? key,
    required this.messageController,
    required this.onSend,
  }) : super(key: key);

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  final TtsSttService _ttsSttService = TtsSttService();
  bool _isListening = false;

  @override
  void dispose() {
    _ttsSttService.stopListening();
    super.dispose();
  }

  void _toggleListening() async {
    if (_isListening) {
      await _ttsSttService.stopListening();
      setState(() => _isListening = false);
    } else {
      final available = await _ttsSttService.initSpeech();
      if (available) {
        setState(() => _isListening = true);
        await _ttsSttService.startListening((text) {
          widget.messageController.text = text;
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.messageController,
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening ? Colors.red : Colors.black,
          ),
          onPressed: _toggleListening,
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            widget.onSend(widget.messageController.text);
          },
        ),
      ],
    );
  }
}
