import 'package:equatable/equatable.dart';
import '../models/registry.dart';

abstract class RegistryState extends Equatable {
  const RegistryState();

  @override
  List<Object> get props => [];
}

class RegistryInitial extends RegistryState {}

class RegistryLoading extends RegistryState {}

class RegistryLoaded extends RegistryState {
  final List<Registry> registries;

  const RegistryLoaded(this.registries);

  @override
  List<Object> get props => [registries];
}

class RegistryError extends RegistryState {
  final String error;

  const RegistryError(this.error);

  @override
  List<Object> get props => [error];
}
