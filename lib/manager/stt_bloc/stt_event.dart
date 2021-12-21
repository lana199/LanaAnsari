part of 'stt_bloc.dart';

abstract class SttEvent extends Equatable {
  const SttEvent();
}

class SttListenStarted extends SttEvent {
  const SttListenStarted();

  @override
  List<Object> get props => [];
}

class SttListenCanceled extends SttEvent {
  const SttListenCanceled();

  @override
  List<Object> get props => [];
}
