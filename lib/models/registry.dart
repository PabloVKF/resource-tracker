import 'package:cloud_firestore/cloud_firestore.dart';

class Registry {
  final String id;
  final int? value;
  final DateTime? date;

  Registry({
    required this.id,
    required this.value,
    required this.date,
  });

  factory Registry.fromJson(Map<String, dynamic> json) {
    return Registry(
      id: json['id'],
      value: json['value'],
      date: json['date'] == null ? null : (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (value != null) "value": value,
      if (date != null) "date": date,
    };
  }
}
