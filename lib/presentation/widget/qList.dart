import 'package:assitant2/manager/qa_bloc/qa_bloc.dart';
import 'package:assitant2/manager/stt_bloc/stt_bloc.dart';
import 'package:assitant2/manager/tts_bloc/tts_bloc.dart';
import 'package:assitant2/presentation/widget/qItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QList extends StatefulWidget {
  const QList({Key key}) : super(key: key);

  @override
  _QListState createState() => _QListState();
}

class _QListState extends State<QList> {
  @override
  void initState() {
    context.read<QaBloc>().add(QaLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QaBloc, QaState>(
      builder: (context, qAState) {
        if (qAState is QaInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (qAState is QaLoadFailure) {
          return Center(
            child: Text('حدث خطأ ما! اعد المحاولة.'),
          );
        } else if (qAState is QaLoadSuccess) {
          return BlocListener<SttBloc, SttState>(
            listenWhen: (_, current) => current is SttRecognitionSuccess,
            listener: (context, sttState) {
              var _ttsBlocState = context.read<TtsBloc>();
              if (sttState is SttRecognitionSuccess) {
                if (_ttsBlocState.state is! TtsPlaying &&
                    _ttsBlocState.state is! TtsPlayInProgress) {
                  // index out of bound exception protection
                  if (sttState.qIndex < qAState.qaList.length) {
                    _ttsBlocState.add(TtsTextVoiceStarted(
                        qAState.qaList[sttState.qIndex].answer));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('لم استطع التعرف على رقم السؤال...')));
                  }
                }
              }
            },
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, int index) => QItem(
                index: index + 1,
                qa: qAState.qaList[index],
              ),
              itemCount: qAState.qaList.length,
            ),
          );
        }

        throw 'UnHandled state QaBloc: $qAState';
      },
    );
  }
}
