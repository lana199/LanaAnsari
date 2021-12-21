part of 'qa_bloc.dart';

abstract class QaState extends Equatable {
  const QaState();
}

class QaInProgress extends QaState {
  const QaInProgress();

  @override
  List<Object> get props => [];
}

class QaLoadSuccess extends QaState {
  final List<QA> qaList;

  const QaLoadSuccess(this.qaList);

  @override
  List<Object> get props => [qaList];
}

class QaLoadFailure extends QaState {
  const QaLoadFailure();

  @override
  List<Object> get props => [];
}
