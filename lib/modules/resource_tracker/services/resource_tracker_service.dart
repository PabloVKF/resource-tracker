import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/registry.dart';

class ResourceTrackerService {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Registry>> getRecords() async {
    final List<Registry> result = [];

    await _db
        .collection('users')
        .doc(_uid)
        .collection('registries')
        .get()
        .then((event) {
      for (var doc in event.docs) {
        final json = doc.data();
        json['id'] = doc.id;
        result.add(Registry.fromJson(json));
      }
    });

    return result;
  }

  Future<void> saveItem(Map<String, dynamic> json) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('registries')
        .add(json);
  }

  Future<void> deleteItem(String id) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('registries')
        .doc(id)
        .delete();
  }

}
