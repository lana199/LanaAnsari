import 'dart:async';

import 'package:assitant2/repositories/speech_to_text_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stt_event.dart';

part 'stt_state.dart';

class SttBloc extends Bloc<SttEvent, SttState> {
  final SpeechToTextRepository _repository;

  SttBloc(this._repository) : super(SttIdle()) {
    _repository.soundLevelStream.listen((event) {
      emit(SttChangeSoundLevel(event));
    });

    _repository.speechRecognitionErrorStream.listen((event) {
      print(event.errorMsg + ' : is permanent?' + event.permanent.toString());
      emit(SttFailure());
    });

    _repository.statusStream.listen((event) {
      if (event == ListeningStatus.Listening) {
        emit(SttListening());
      } else {
        emit(SttIdle());
      }
    });

    _repository.speechRecognitionStream.listen((event) {

      String _questionIndex;
      if (event.finalResult) {
        _questionIndex = event.recognizedWords;

        if (SpeechToTextRepository.arMapper.containsKey(_questionIndex)) {
          _questionIndex =
              SpeechToTextRepository.arMapper[event.recognizedWords].toString();
        }
        if (int.tryParse(_questionIndex) != null) {
          emit(SttRecognitionSuccess(int.parse(_questionIndex)));

        } else {
          emit(SttIndexRecognitionFailure());
        }
      }
    });
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }

  @override
  Stream<SttState> mapEventToState(
    SttEvent event,
  ) async* {
    if (event is SttListenStarted) {
      _sttListenStartedHandler();
    } else if (event is SttListenCanceled) {
      _sttListenCanceledHandler();
    }
  }

  void _sttListenStartedHandler() {

    _repository.startListening();
  }

  void _sttListenCanceledHandler() {

    _repository.cancelListening();
  }
}
