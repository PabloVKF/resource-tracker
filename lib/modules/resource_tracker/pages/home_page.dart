import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resource_tracker/modules/resource_tracker/pages/components/registry_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../../route_generator.dart';
import '../bloc/registry_bloc.dart';
import '../bloc/registry_event.dart';
import '../bloc/registry_state.dart';
import '../models/registry.dart';
import 'components/registry_chart.dart';
import 'registry_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RegistryBloc>().add(LoadRegistries());
  }

  Future<void> _exportToCSV(BuildContext context) async {
    final state = context.read<RegistryBloc>().state;
    if (state is RegistryLoaded) {
      final registries = state.registries;
      final csvData = _generateCSV(registries);

      try {
        final directory = await getTemporaryDirectory();
        final path = "${directory.path}/registries.csv";
        final file = File(path);
        await file.writeAsString(csvData);
        final xFile = XFile(file.path);

        await Share.shareXFiles([xFile], subject: 'Registro de Leituras');
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao exportar CSV: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum dado disponível para exportação')),
      );
    }
  }

  String _generateCSV(List<Registry> registries) {
    final List<List<dynamic>> rows = [];

    rows.add(['Nome', 'Valor', 'Data']);

    for (final registry in registries) {
      rows.add([registry.name, registry.value, registry.date.toString()]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  void _exitApp(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(RouteGenerator.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource tracker'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync),
                      SizedBox(width: 8),
                      Text('Recarregar'),
                    ],
                  ),
                  onTap: () {
                    context.read<RegistryBloc>().add(LoadRegistries());
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Baixar CSV'),
                    ],
                  ),
                  onTap: () => _exportToCSV(context),
                ),
                PopupMenuItem(
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Sair'),
                    ],
                  ),
                  onTap: () => _exitApp(context),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<RegistryBloc, RegistryState>(
            builder: (context, state) {
              final registries = <Registry>[];
              if (state is RegistryLoaded) {
                registries.addAll(state.registries);
              }
              final lastRegistryName =
                  registries.isEmpty ? null : registries.first.name;
              final registriesOfLastRegistries = registries.where((e) {
                return e.name == lastRegistryName;
              });
              final recentRegistries =
                  registriesOfLastRegistries.take(5).toList().reversed.toList();
              return Padding(
                padding: const EdgeInsets.only(
                  top: 64,
                  right: 16,
                  left: 16,
                ),
                child: Registrychart(
                  registries: recentRegistries,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Regisors',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          BlocBuilder<RegistryBloc, RegistryState>(
            builder: (context, state) {
              if (state is RegistryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RegistryLoaded) {
                return Expanded(
                  child: RegistryList(
                    registries: state.registries,
                  ),
                );
              } else if (state is RegistryError) {
                return Center(child: Text(state.error));
              } else {
                return const Center(child: Text("Sem registros"));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (_) {
                return Dialog.fullscreen(
                  child: RegistryFormPage(
                    bloc: context.read<RegistryBloc>(),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
