class RegistryFormData {
  int? value;
  DateTime? date;

  Map<String, dynamic> toJson() {
    return {
      if (value != null) "value": value,
      if (date != null) "date": date,
    };
  }
}