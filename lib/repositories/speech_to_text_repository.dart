import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum ListeningStatus { Listening, NotListening }

class SpeechToTextRepository {
  static final Map<String, int> arMapper = {
    'واحد': 1,
    'اثنين': 2,
    'ثلاثه': 3,
    'اربعه': 4,
    'خمسه': 5,
    'سته': 6,
    'سبعه': 7,
    'ثمانيه': 8,
    'تسعه': 9,
    'عشره': 10,
    'احد عشر': 11,
    'اثنا عشر': 12,
    'ثلاثه عشر': 13,
  };

  /// sound level for UI
  final StreamController<double> _soundLevelSC = StreamController<double>();

  /// changes from listening to not listening.
  final StreamController<ListeningStatus> _statusSC =
      StreamController<ListeningStatus>();

  /// when error send the event to bloc
  final StreamController<SpeechRecognitionError> _speechRecognitionErrorSC =
      StreamController<SpeechRecognitionError>();

  /// stream of recognized words
  final StreamController<SpeechRecognitionResult> _speechRecognitionResultSC =
      StreamController<SpeechRecognitionResult>();

  /// the plugin object
  final SpeechToText _speech = SpeechToText();

  /// if the init completed or not
  bool _hasSpeech = false;

  String _localId = 'ar_SA';

  SpeechToTextRepository() {
    init();
  }

  Stream<double> get soundLevelStream => _soundLevelSC.stream;

  Stream<SpeechRecognitionResult> get speechRecognitionStream =>
      _speechRecognitionResultSC.stream;

  Stream<SpeechRecognitionError> get speechRecognitionErrorStream =>
      _speechRecognitionErrorSC.stream;

  Stream<ListeningStatus> get statusStream => _statusSC.stream;

  /// return true if the initialization of STT was successful, false if not.
  ///
  /// This method must be called before any other speech functions.
  /// If this method returns false no further [SpeechToText] methods
  /// should be used. Should only be called once if successful but does protect
  /// itself if called repeatedly. False usually means that the user has denied
  /// permission to use speech. The usual option in that case is to give them
  /// instructions on how to open system settings and grant permission.
  ///
  /// [onError] is an optional listener for errors like
  /// timeout, or failure of the device speech recognition.
  ///
  /// [onStatus] is an optional listener for status changes from
  /// listening to not listening.
  Future<bool> init() async {
    _hasSpeech = await _speech.initialize(
        onStatus: (status) => _statusSC.sink.add(
            status == SpeechToText.listeningStatus
                ? ListeningStatus.Listening
                : ListeningStatus.NotListening),
        onError: (errorNotification) =>
            _speechRecognitionErrorSC.sink.add(errorNotification),
        // debugLogging: true,
        finalTimeout: Duration.zero);
    return _hasSpeech;
  }

  /// Cancels the current listen for speech if active, does nothing if not.
  Future<void> cancelListening() async {
    if (!_hasSpeech) {
      print('not init yet!!');
      return;
    }
    await _speech.cancel();
  }

  /// Starts a listening session for speech and converts it to text,
  /// invoking the provided [onResult] method as words are recognized.
  ///
  /// Cannot be used until a successful [initialize] call. There is a
  /// time limit on listening imposed by both Android and iOS. The time
  /// depends on the device, network, etc. Android is usually quite short,
  /// especially if there is no active speech event detected, on the order
  /// of ten seconds or so.
  ///
  /// [onResult] is an optional listener that is notified when words
  /// are recognized.
  ///
  /// [listenFor] sets the maximum duration that it will listen for, after
  /// that it automatically stops the listen for you.
  ///
  /// [pauseFor] sets the maximum duration of a pause in speech with no words
  /// detected, after that it automatically stops the listen for you.
  ///
  /// [partialResults] if true the listen reports results as they are recognized,
  //   when false only final results are reported. Defaults to true.
  void startListening() {
    if (!_hasSpeech) {
      print('not init yet!!');
      return;
    }
    _speech.listen(
        onResult: (result) => _speechRecognitionResultSC.sink.add(result),
        listenFor: Duration(seconds: 3),
        pauseFor: Duration(seconds: 5),
        partialResults: false,
        localeId: _localId,
        onSoundLevelChange: (level) => _soundLevelSC.sink.add(level),
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  /// clean-up (release) all the objects from memory
  /// prevent memory leak
  Future<void> dispose() async {
    await _soundLevelSC.close();
    await _statusSC.close();
    await _speechRecognitionErrorSC.close();
    await _speechRecognitionResultSC.close();
    if (!_hasSpeech) {
      print('not init yet!!');
      return;
    }
    await _speech.cancel();
  }
}
