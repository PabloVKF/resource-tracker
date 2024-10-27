import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/registry.dart';
import '../services/resource_tracker_service.dart';
import 'registry_event.dart';
import 'registry_state.dart';

class RegistryBloc extends Bloc<RegistryEvent, RegistryState> {
  final ResourceTrackerService resourceTrackerService;

  RegistryBloc(this.resourceTrackerService) : super(RegistryInitial()) {
    on<LoadRegistries>(_onLoadRegistries);
    on<AddRegistry>(_onAddRegistry);
    on<DeleteRegistry>(_onDeleteRegistry);
  }

  Future<void> _onLoadRegistries(
    LoadRegistries event,
    Emitter<RegistryState> emit,
  ) async {
    emit(RegistryLoading());

    try {
      final registries = await resourceTrackerService.getRecords();

      // Sort by date, descending, to have the most recent records first
      registries.sort((a, b) => b.date.compareTo(a.date));

      // Group registries by name
      final groupedByName = <String, List<Registry>>{};
      for (var registry in registries) {
        groupedByName.putIfAbsent(registry.name, () => []).add(registry);
      }

      // Calculate growth within each group
      for (var group in groupedByName.values) {
        for (int i = 0; i < group.length; i++) {
          if (i == group.length - 1) {
            group[i].growth = 0.0;
          } else {
            final current = group[i];
            final previous = group[i + 1];

            if (previous.value != 0) {
              current.growth =
                  ((current.value - previous.value) / previous.value) * 100;
            } else {
              current.growth = current.value > 0 ? 100.0 : 0.0;
            }
          }
        }
      }

      // Flatten the grouped registries back into a single list
      final List<Registry> updatedRegistries =
          groupedByName.values.expand((group) => group).toList();

      emit(RegistryLoaded(updatedRegistries));
    } catch (e) {
      emit(RegistryError("Falha ao carregar os registros: $e"));
    }
  }

  Future<void> _onAddRegistry(
    AddRegistry event,
    Emitter<RegistryState> emit,
  ) async {
    try {
      await resourceTrackerService.saveItem(event.registryJson);
      add(LoadRegistries());
    } catch (e) {
      emit(RegistryError("Falha ao carregar os registros: $e"));
    }
  }

  Future<void> _onDeleteRegistry(
    DeleteRegistry event,
    Emitter<RegistryState> emit,
  ) async {
    try {
      await resourceTrackerService.deleteItem(event.registryId);
      add(LoadRegistries());
    } catch (e) {
      emit(RegistryError("Falha ao carregar os registros: $e"));
    }
  }
}
