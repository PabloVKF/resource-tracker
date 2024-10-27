class RegistryFormData {
  String? name;
  int? value;
  DateTime? date;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) "name": name,
      if (value != null) "value": value,
      if (date != null) "date": date,
    };
  }
}