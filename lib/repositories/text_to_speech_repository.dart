import 'package:flutter/gestures.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

enum TtsPluginState { playing, stopped, error }

class TextToSpeechRepository {
  FlutterTts flutterTts;

  final StreamController<TtsPluginState> _ttsStateSC =
      StreamController<TtsPluginState>();

  final StreamController<String> _wordProgressSC = StreamController<String>();

  Stream<TtsPluginState> get ttsStateStream => _ttsStateSC.stream;

  Stream<String> get wordProgressStream => _wordProgressSC.stream;

   var _isDone = false;

  TextToSpeechRepository() {
    init();
  }

  Future<void> init() async {
    flutterTts = FlutterTts();

    // flutterTts.setEngine(await flutterTts.getDefaultEngine);

    await flutterTts.setEngine('com.google.android.tts');

    await flutterTts.setVolume(5.0);

    flutterTts.setLanguage('ar');

    // when the the voice start playing
    flutterTts
        .setStartHandler(() => _ttsStateSC.sink.add(TtsPluginState.playing));

    // when the voice stops playing
    flutterTts.setCompletionHandler(
        () => _ttsStateSC.sink.add(TtsPluginState.stopped));

    // when error occur while plating or on init the tts object
    flutterTts.setErrorHandler((error) {
      print('flutterTts error : ' + error);

      _ttsStateSC.sink.add(TtsPluginState.error);
    });
   

    // called every time the voice say a word
    // [text] is overall answer
    // [word] last word the voice say
    flutterTts.setProgressHandler((text, start, end, word) {
      if (!_isDone) {
        _wordProgressSC.sink.add(text);
        _isDone = true;
      }
    });
  }

  // start speaking
  Future<void> speak(String textToSay) async {
    if (textToSay != null && textToSay.isNotEmpty) {
      _isDone = false;
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(textToSay);
    }
  }

  // stop speaking
  Future<void> stop() async {
    await flutterTts.stop();
  }

// clean-up the objets from memory
  Future<void> dispose() async {
    await flutterTts.stop();
    await _wordProgressSC.close();
    await _ttsStateSC.close();
  }
}
