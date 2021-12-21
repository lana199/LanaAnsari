import 'package:assitant2/repositories/models/qa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreRepository {
  final FirebaseFirestore _fireStore;

  FireStoreRepository() : _fireStore = FirebaseFirestore.instance;

  Future<List<QA>> getQAList() async {
    final List<QA> _qaList = [];
    var snapshot = await _fireStore.collection('qa').get();

    snapshot.docs.forEach((element) {
      _qaList.add(QA.formMap(element.data()));
    });
    return List.unmodifiable(_qaList);
  }
}
