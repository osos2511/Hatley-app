import '../../../domain/entities/governorate_entity.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState{
  final List<GovernorateEntity> governorates;
  LocationLoaded(this.governorates);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}