import 'package:assitant2/manager/stt_bloc/stt_bloc.dart';
import 'package:assitant2/manager/tts_bloc/tts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FABStt extends StatelessWidget {
  const FABStt({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SttBloc, SttState>(
      listenWhen: (_, current) =>
          current is SttIndexRecognitionFailure || current is SttFailure,
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (state is SttFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('حدث خطأ ما! اعد المحاولة.')));
        } else if (state is SttIndexRecognitionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('لم استطع التعرف على رقم السؤال...')));
        }
      },
      builder: (context, state) {
        if (state is SttChangeSoundLevel) {
          return Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .26,
                    spreadRadius: state.level * 1.5,
                    color: Colors.pink.withOpacity(.5))
              ],
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: IconButton(
              icon: Icon(Icons.mic_off),
              onPressed: () => context.read<SttBloc>().add(SttListenCanceled()),
            ),
          );
        }

        return BlocBuilder<TtsBloc, TtsState>(
          builder: (context, ttsState) {
            return Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .26,
                      spreadRadius: 0,
                      color: Colors.pink.withOpacity(.7))
                ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
                onPressed: state is SttListening ||
                        ttsState is TtsPlaying ||
                        ttsState is TtsPlayInProgress
                    ? null
                    : () => context.read<SttBloc>().add(SttListenStarted()),
              ),
            );
          },
        );
      },
    );
  }
}
