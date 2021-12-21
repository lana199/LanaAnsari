import 'package:assitant2/repositories/models/qa.dart';
import 'package:flutter/material.dart';

class QItem extends StatelessWidget {
  final QA qa;
  final int index;

  const QItem({ this.index, this.qa})
      : assert(index != null),
        assert(qa != null),
        super();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(index.toString()),
      ),
      title: Text(qa.question),
    );
  }
}
