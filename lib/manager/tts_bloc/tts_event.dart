part of 'tts_bloc.dart';

abstract class TtsEvent extends Equatable {
  const TtsEvent();
}

class TtsTextVoiceStarted extends TtsEvent {
  final String text;

  const TtsTextVoiceStarted(this.text);

  @override
  List<Object> get props => [text];
}

class TtsTextVoiceStopped extends TtsEvent {
  const TtsTextVoiceStopped();

  @override
  List<Object> get props => [];
}
