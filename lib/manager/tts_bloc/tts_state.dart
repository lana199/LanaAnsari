part of 'tts_bloc.dart';

abstract class TtsState extends Equatable {
  const TtsState();
}

class TtsInitial extends TtsState {
  @override
  List<Object> get props => [];
}

class TtsPlaying extends TtsState {
  const TtsPlaying();

  @override
  List<Object> get props => [];
}

class TtsPlayInProgress extends TtsState {
  final String word;

  const TtsPlayInProgress(this.word);

  @override
  List<Object> get props => [];
}

class TtsStop extends TtsState {
  const TtsStop();

  @override
  List<Object> get props => [];
}

class TtsFailure extends TtsState {
  const TtsFailure();

  @override
  List<Object> get props => [];
}
