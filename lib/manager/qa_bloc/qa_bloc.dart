import 'dart:async';

import 'package:assitant2/repositories/firestore_repository.dart';
import 'package:assitant2/repositories/models/qa.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'qa_event.dart';

part 'qa_state.dart';

class QaBloc extends Bloc<QaEvent, QaState> {
  final FireStoreRepository _repository;

  QaBloc(this._repository) : super(QaInProgress());

  @override
  Stream<QaState> mapEventToState(
    QaEvent event,
  ) async* {
    if (event is QaLoaded) {
      yield* _qALoadedHandler();
    }
  }

  Stream<QaState> _qALoadedHandler() async* {
    try {
      var _qAList = await _repository.getQAList();
      yield QaLoadSuccess(_qAList);
    } on Exception {
      yield QaLoadFailure();
    }
  }
}
