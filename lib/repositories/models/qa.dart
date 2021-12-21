import 'package:equatable/equatable.dart';

class QA extends Equatable {
  final String question;
  final String answer;

  QA(this.question, this.answer);

  factory QA.formMap(Map<String, dynamic> map) {
    return QA(map['question'], map['answer']);
  }


  @override
  List<Object> get props => [question, answer];
}
