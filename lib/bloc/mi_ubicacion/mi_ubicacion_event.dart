part of 'mi_ubicacion_bloc.dart';

@immutable
abstract class MiUbicacionEvent {}

class OnVerificaGPS extends MiUbicacionEvent{}

class OnIniciarSeguimiento extends MiUbicacionEvent{}

class OnSeguirUbicacion extends MiUbicacionEvent{}

class OnGPSDesactivado extends MiUbicacionEvent{}

class OnUbicacionCambio extends MiUbicacionEvent {
  final LatLng ubicacion;
  OnUbicacionCambio(this.ubicacion);
}