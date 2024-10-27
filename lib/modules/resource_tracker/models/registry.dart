import 'package:cloud_firestore/cloud_firestore.dart';

class Registry {
  final String id;
  final String name;
  final int value;
  final DateTime date;
  double growth;

  Registry({
    required this.id,
    required this.name,
    required this.value,
    required this.date,
    this.growth = 0.0,
  });

  bool get isAnomaly => growth >= 20 || growth <= -20;

  String get formatedGrowth {
    final signal = growth < 0 ? '' : '+';
    return "$signal${growth.toInt()}%";
  }

  factory Registry.fromJson(Map<String, dynamic> json) {
    return Registry(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "value": value,
      "date": date,
    };
  }
}
