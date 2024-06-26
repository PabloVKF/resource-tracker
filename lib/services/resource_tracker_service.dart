import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/registry.dart';

class ResourceTrackerService {
  Future<List<Registry>> getRecords() async {
    final db = FirebaseFirestore.instance;
    final List<Registry> result = [];

    await db.collection("registries").get().then(
      (event) {
        for (var doc in event.docs) {
          final json = (doc.data());
          json['id'] = doc.id;
          result.add(Registry.fromJson(json));
        }
      },
    );

    return result;
  }

  Future<void> saveItem(Map<String, dynamic> json) async {
    final db = FirebaseFirestore.instance;
    await db.collection("registries").add(json);
  }

  Future<void> deleteItem(String id) async {
    final db = FirebaseFirestore.instance;
    await db.collection("registries").doc(id).delete();
  }
}
