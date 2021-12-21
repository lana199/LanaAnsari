import 'dart:async';

import 'package:assitant2/repositories/text_to_speech_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tts_event.dart';

part 'tts_state.dart';

class TtsBloc extends Bloc<TtsEvent, TtsState> {
  final TextToSpeechRepository _repository;

  TtsBloc(this._repository) : super(TtsInitial()) {
    _repository.ttsStateStream.listen((event) {
      if (event == TtsPluginState.playing) {
        emit(TtsPlaying());
      } else if (event == TtsPluginState.stopped) {
        emit(TtsStop());
      } else if (event == TtsPluginState.error) {
        emit(TtsFailure());
      }
    });
    _repository.wordProgressStream.listen((event) {
      emit(TtsPlayInProgress(event));
    });
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }

  @override
  Stream<TtsState> mapEventToState(
    TtsEvent event,
  ) async* {
    if (event is TtsTextVoiceStopped) {
      _repository.stop();
    } else if (event is TtsTextVoiceStarted) {
      _repository.speak(event.text);
    }
  }
}
