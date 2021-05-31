part of 'mi_ubicacion_bloc.dart';

@immutable
class MiUbicacionState {
  final bool gpsActivo;
  final bool existeUbicacion;
  final bool siguiendo;
  final LatLng ubicacion;

  MiUbicacionState({
    this.gpsActivo = false, 
    this.existeUbicacion = false, 
    this.siguiendo = true, 
    this.ubicacion
  });

  MiUbicacionState copyWith({
    bool gpsActivo,
    bool existeUbicacion,
    bool siguiendo,
    LatLng ubicacion
  }) => new MiUbicacionState(
    gpsActivo: gpsActivo ?? this.gpsActivo,
    existeUbicacion: existeUbicacion ?? this.existeUbicacion,
    siguiendo: siguiendo ?? this.siguiendo,
    ubicacion: ubicacion ?? this.ubicacion
  );  
}