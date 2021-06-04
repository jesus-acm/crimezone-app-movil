import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crimezone_app/helpers/custom_image.dart';
import 'package:crimezone_app/models/crimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {

  MapaBloc() : super(MapaState());


  GoogleMapController _mapController;


  void initMapa(GoogleMapController controller){
    if(!state.mapaListo){
      this._mapController = controller;
      add(OnMapaListo());
    }
  }


  void moverCamara(LatLng destino) async{
    try {
      final cameraUpdate = CameraUpdate.newLatLng(destino);
      await this._mapController?.animateCamera(cameraUpdate);
    } catch (e) {
      this._mapController = null;
      add(OnCerrarMapa());
      print('Mover camara: $e');
    }
  }

  List<Crimen> crimenesCercanosUbicacion(LatLng ubicacion, bool banderaPeaton, bool banderaTransporte){
    List<Crimen> crimenesCercanos = <Crimen>[];
    if(banderaPeaton){
      state.crimenesPeaton.forEach((crimen){ 
        final distancia = Geolocator.distanceBetween(
          ubicacion.latitude, 
          ubicacion.longitude, 
          crimen.lat, 
          crimen.long
        );

        if(distancia < 1000.0){
          crimenesCercanos.add(crimen);
        }
      });
    }

    if(banderaTransporte){
      state.crimenesTransporte.forEach((crimen){ 
        final distancia = Geolocator.distanceBetween(
          ubicacion.latitude, 
          ubicacion.longitude, 
          crimen.lat, 
          crimen.long
        );

        if(distancia < 1000.0){
          crimenesCercanos.add(crimen);
        }
      });
    }

    return crimenesCercanos;
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if(event is OnMapaListo){
      yield state.copyWith(mapaListo: true);

    }else if(event is OnCerrarMapa){
      yield state.copyWith(mapaListo: false);

    }else if(event is OnOpcionPeaton){
      if(!state.manual && (event.ubicacion != null))
        add(OnCargarMarkers(
          this.crimenesCercanosUbicacion(event.ubicacion, !state.peaton, state.transporte),
          event.ubicacion
        ));
      yield state.copyWith(peaton: !state.peaton);

    }else if(event is OnOpcionTransporte){
      if(!state.manual && (event.ubicacion != null))
        add(OnCargarMarkers(
          this.crimenesCercanosUbicacion(event.ubicacion, state.peaton, !state.transporte),
          event.ubicacion
        ));
      yield state.copyWith(transporte: !state.transporte);

    }else if(event is OnDbLista){
      yield state.copyWith(
        dbLista: true, 
        crimenesPeaton: event.crimenesPeaton,
        crimenesTransporte: event.crimenesTransporte
      );

    }else if(event is OnNuevaUbicacion){
      yield* _onNuevaUbicacion(event);

    }else if(event is OnCargarMarkers){
      yield* _onCargarMarkers(event);

    }else if(event is OnActivarManual){
      yield state.copyWith(manual: true);
      
    }else if(event is OnDesactivarManual){
      yield state.copyWith(manual: false);
      
    }else if(event is OnBorrarMarkers){
      yield state.copyWith(marcadores: new Map());
      
    }else if(event is OnMovioMapa){
      yield state.copyWith(ubicacionMapa: event.centroMapa);

    }else if(event is OnActivarVisualizando){
      yield state.copyWith(visualizando: true);

    }else if(event is OnDesactivarVisualizando){
      yield state.copyWith(visualizando: false);

    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async*{
    await this.moverCamara(event.ubicacion);

    add(OnCargarMarkers(
      crimenesCercanosUbicacion(
        event.ubicacion,
        state.peaton,
        state.transporte
      ),
      event.ubicacion
    ));

    yield state;
  }

  Stream<MapaState> _onCargarMarkers(OnCargarMarkers event) async*{
    
    final marcadores = await Future.wait([
      marcadorUbicacion(),
      marcadorRojo(),
      marcadorNaranja(),
      marcadorVerde()
    ]);
    Map<String, Marker> nuevosMarcadores = new Map();
    nuevosMarcadores['mi-ubicacion'] = Marker(
      markerId: MarkerId('mi-ubicacion'),
      position: LatLng(event.ubicacionActual.latitude, event.ubicacionActual.longitude),
      icon: marcadores[0],
    );
    
    event.crimenes.forEach((crimen){

      BitmapDescriptor icono;
      if(crimen.color == "Rojo"){
        icono = marcadores[1];
      }else if(crimen.color == "Naranja"){
        icono = marcadores[2];
      }else{
        icono = marcadores[3];
      }

      nuevosMarcadores['${ crimen.id }'] = Marker(
        markerId: MarkerId('${ crimen.id }'),
        position: LatLng(crimen.lat, crimen.long),
        anchor: Offset(0.5, 0.5),
        icon: icono,
        infoWindow: InfoWindow(
          title: '${ crimen.categoria }',
          snippet: 'Fecha: ${ crimen.fecha.toString().split(' ').first }'
        )
      );
      
    });

    yield state.copyWith(marcadores: nuevosMarcadores);
  }


}
