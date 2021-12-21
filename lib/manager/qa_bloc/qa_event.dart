part of 'qa_bloc.dart';

abstract class QaEvent extends Equatable {
  const QaEvent();
}

/// load Q&A from the database
class QaLoaded extends QaEvent {
  const QaLoaded();

  @override
  List<Object> get props => [];
}
