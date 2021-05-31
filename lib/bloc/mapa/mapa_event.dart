part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapaListo extends MapaEvent{}

class OnCerrarMapa extends MapaEvent{}

class OnOpcionPeaton extends MapaEvent{
  final LatLng ubicacion;

  OnOpcionPeaton(this.ubicacion);
}

class OnOpcionTransporte extends MapaEvent{
  final LatLng ubicacion;

  OnOpcionTransporte(this.ubicacion);
}

class OnDbLista extends MapaEvent{
  final List<Crimen> crimenesPeaton;
  final List<Crimen> crimenesTransporte;

  OnDbLista({this.crimenesPeaton, this.crimenesTransporte});
}

class OnNuevaUbicacion extends MapaEvent{
  final LatLng ubicacion;

  OnNuevaUbicacion(this.ubicacion);
}

class OnCargarMarkers extends MapaEvent{
  final List<Crimen> crimenes;
  final LatLng ubicacionActual;

  OnCargarMarkers(this.crimenes, this.ubicacionActual);
}

class OnBorrarMarkers extends MapaEvent{}

class OnActivarManual extends MapaEvent{}

class OnDesactivarManual extends MapaEvent{}

class OnActivarVisualizando extends MapaEvent{}

class OnDesactivarVisualizando extends MapaEvent{}

class OnMovioMapa extends MapaEvent{
  final LatLng centroMapa;
  OnMovioMapa(this.centroMapa);  
}