import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/registry_bloc.dart';
import '../../bloc/registry_event.dart';
import '../../models/registry.dart';

class RegistryList extends StatelessWidget {
  final List<Registry> registries;

  const RegistryList({
    super.key,
    required this.registries,
  });

  @override
  Widget build(BuildContext context) {
    if (registries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Ainda sem registros. Acrescente uma nova leiura clicando no botão de adicionar!",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return ListView.builder(
      itemCount: registries.length + 1,
      itemBuilder: (context, index) {
        if (index < registries.length) {
          final registry = registries[index];
          final stringData =
              '${registry.date.day}/${registry.date.month}/${registry.date.year}';
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          const warningMessage =
              "Alerta de possível vazamento: Variação ultrapassou 20%";

          return ListTile(
            leading: registry.isAnomaly
                ? Tooltip(
                    message: warningMessage,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(warningMessage)),
                        );
                      },
                      child: Icon(
                        Icons.warning,
                        color: colorScheme.error,
                      ),
                    ),
                  )
                : const Icon(Icons.water_drop_outlined),
            title: Row(
              children: [
                Text(
                  "${registry.value} m³",
                  style: textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Badge(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  label: Text(
                    registry.formatedGrowth,
                    style: textTheme.bodySmall?.copyWith(
                      color: registry.isAnomaly
                          ? colorScheme.onError
                          : colorScheme.onSecondary,
                    ),
                  ),
                  backgroundColor:
                      registry.isAnomaly ? null : colorScheme.secondary,
                ),
              ],
            ),
            subtitle: Text("${registry.name} - $stringData"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext _) {
                    final theme = Theme.of(context);
                    final errorColor = theme.colorScheme.error;
                    final styleTextError = theme.textTheme.bodyMedium?.copyWith(
                      color: errorColor
                    );
                    return AlertDialog(
                      title: const Text('Confirme a deleção'),
                      content: const Text(
                          'Você tem certeza que gostaria de deletar o registro? Essa alteração não poderá ser desfeita.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<RegistryBloc>()
                                .add(DeleteRegistry(registry.id));
                            Navigator.of(context).pop();
                          },
                          child: Text('Deletar', style: styleTextError),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        } else {
          return const SizedBox(height: 64);
        }
      },
    );
  }
}
