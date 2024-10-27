import 'package:equatable/equatable.dart';

abstract class RegistryEvent extends Equatable {
  const RegistryEvent();

  @override
  List<Object> get props => [];
}

class LoadRegistries extends RegistryEvent {}

class AddRegistry extends RegistryEvent {
  final Map<String, dynamic> registryJson;

  const AddRegistry(this.registryJson);

  @override
  List<Object> get props => [registryJson];
}

class DeleteRegistry extends RegistryEvent {
  final String registryId;

  const DeleteRegistry(this.registryId);

  @override
  List<Object> get props => [registryId];
}
