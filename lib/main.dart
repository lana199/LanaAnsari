import 'package:assitant2/manager/auth_bloc/auth_bloc.dart';
import 'package:assitant2/manager/qa_bloc/qa_bloc.dart';
import 'package:assitant2/manager/tts_bloc/tts_bloc.dart';
import 'package:assitant2/presentation/screen/create_account.dart';
import 'package:assitant2/presentation/screen/home.dart';
import 'package:assitant2/presentation/screen/login.dart';
import 'package:assitant2/repositories/firebase_auth_repository.dart';
import 'package:assitant2/repositories/firestore_repository.dart';
import 'package:assitant2/repositories/speech_to_text_repository.dart';
import 'package:assitant2/repositories/text_to_speech_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'manager/stt_bloc/stt_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Wait for Firebase to initialize then run the app
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => FireStoreRepository(),
        ),
        RepositoryProvider(
          create: (context) => FireBaseAuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => SpeechToTextRepository(),
        ),
        RepositoryProvider(
          create: (context) => TextToSpeechRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            TtsBloc(RepositoryProvider.of<TextToSpeechRepository>(context)),
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,

          ],
          supportedLocales: [Locale('ar')],
          locale: Locale('ar'),
          title: 'مساعدك',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AuthBloc(
                        RepositoryProvider.of<FireBaseAuthRepository>(context)),
                    child: Login(),
                  ),
                );

              case '/create-account':
                return MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AuthBloc(
                        RepositoryProvider.of<FireBaseAuthRepository>(context)),
                    child: CreateAccount(),
                  ),
                );
              case '/home':
                return MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => SttBloc(
                            RepositoryProvider.of<SpeechToTextRepository>(
                                context)),
                      ),
                      BlocProvider<QaBloc>(
                        create: (context) => QaBloc(
                            RepositoryProvider.of<FireStoreRepository>(
                                context)),
                      ),
                    ],
                    child: Home(),
                  ),
                );
            }
            throw Exception('unhandled route: ' + settings.name);
          },
        ),
      ),
    );
  }
}
