part of 'stt_bloc.dart';

abstract class SttState extends Equatable {
  const SttState();
}

class SttIdle extends SttState {
  @override
  List<Object> get props => [];
}

/// Indicate the listening state
///
/// The not Listening state indicated by [SttIdle] state
class SttListening extends SttState {
  @override
  List<Object> get props => [];
}

class SttChangeSoundLevel extends SttState {
  final double level;

  SttChangeSoundLevel(this.level);

  @override
  List<Object> get props => [level];
}

class SttFailure extends SttState {
  @override
  List<Object> get props => [];
}

class SttIndexRecognitionFailure extends SttState {
  @override
  List<Object> get props => [];
}

class SttRecognitionSuccess extends SttState {
  final int _qIndex;

  // because the lists start from 0 and the user index start from 1 so (-1).
  int get qIndex => _qIndex - 1;

  SttRecognitionSuccess(this._qIndex);

  @override
  List<Object> get props => [_qIndex];
}
