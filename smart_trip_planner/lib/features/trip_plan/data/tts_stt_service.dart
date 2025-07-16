import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class TtsSttService {
  // Speech to Text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastResult = '';

  // Text to Speech
  final FlutterTts _flutterTts = FlutterTts();

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  bool get isListening => _isListening;
  String get lastResult => _lastResult;

  Future<void> startListening(Function(String) onResult) async {
    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        _lastResult = result.recognizedWords;
        onResult(_lastResult);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      localeId: 'en_US',
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
  }

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }
} 