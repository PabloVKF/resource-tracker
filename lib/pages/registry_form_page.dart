import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resource_tracker/models/registry_form_data.dart';
import 'package:resource_tracker/services/resource_tracker_service.dart';

class RegistryFormPage extends StatefulWidget {
  const RegistryFormPage({
    super.key,
  });

  @override
  State<RegistryFormPage> createState() => _RegistryFormPageState();
}

class _RegistryFormPageState extends State<RegistryFormPage> {
  final _formData = RegistryFormData();
  final _formkey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _formData.date = DateTime.now();
  }

  Future<void> saveRegistry() async {
    _isLoading = true;

    try {
      if (!_formkey.currentState!.validate()) {
        return;
      }

      final Map<String, dynamic> json = _formData.toJson();
      ResourceTrackerService().saveItem(json);

      Navigator.of(context).pop();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now()
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(_picked);
        _formData.date = _picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Novo registro'),
        actions: [
          TextButton(
              onPressed: _isLoading ? null : saveRegistry,
              child: const Text('Salvar'))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Valor da leitura (obrigatório)',
                    hintText: 'Ex: 3045',
                  ),
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Campo obritgatório';
                    }
                    return null;
                  },
                  onChanged: (String text) {
                    _formData.value = text.isEmpty ? null : int.tryParse(text);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextFormField(
                  controller: _dateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Dia do registro',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Campo obritgatório';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: _selectDate,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: FilledButton(
                  onPressed: saveRegistry,
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Salvar')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
