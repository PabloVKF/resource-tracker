import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:resource_tracker/models/registry.dart';
import 'package:resource_tracker/pages/registry_form_page.dart';
import 'package:resource_tracker/services/resource_tracker_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  List<Registry> _registries = [];

  @override
  void initState() {
    super.initState();
    loadingData();
  }

  Future<void> loadingData() async {
    _isLoading = true;

    try {
      _registries = await ResourceTrackerService().getRecords();
      _registries.sort((a, b) {
        if (a.date == null) return 0;
        if (b.date == null) return 1;
        return a.date!.compareTo(b.date!);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Leituras'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (Registry registry in _registries)
                    Slidable(
                      key: ValueKey('slidable${registry.id}'),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () async {
                          await ResourceTrackerService()
                              .deleteItem(registry.id);
                        }),
                        children: [
                          SlidableAction(
                            onPressed: (_) async {
                              await ResourceTrackerService()
                                  .deleteItem(registry.id);
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.errorContainer,
                            foregroundColor:
                                Theme.of(context).colorScheme.onErrorContainer,
                            icon: Icons.delete,
                            label: 'Deletar',
                          ),
                        ],
                      ),
                      child: ListTile(
                        key: ValueKey(registry.id),
                        leading: const Icon(Icons.water_drop_outlined),
                        title:
                            Text(registry.value?.toString() ?? '<Sem valor>'),
                        subtitle: Text(registry.date != null
                            ? DateFormat('dd/MM/yyyy').format(registry.date!)
                            : '<Sem data>'),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (_) {
                return const Dialog.fullscreen(
                  child: RegistryFormPage(),
                );
              });
          loadingData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
