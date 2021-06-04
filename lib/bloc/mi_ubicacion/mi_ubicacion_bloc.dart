import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:location/location.dart' show Location;

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  
  MiUbicacionBloc() : super(MiUbicacionState());

  StreamSubscription<Position> _positionSubscription;

  void iniciarSeguimiento({bool gps = false}){
    if(state.gpsActivo || gps){
      print('==========> INICIANDO SEGUIMIENTO');
      this._positionSubscription = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 20
      ).listen((Position position) { 
        final nuevaUbicacion = new LatLng(position.latitude, position.longitude);
        add(OnUbicacionCambio(nuevaUbicacion));
      }, onError: (error, _){
        if('$error' == 'The location service on the device is disabled.'){
          add(OnGPSDesactivado());
          print('============> SE DESACTIVO EL GPS');
        }
      }, cancelOnError: true);//Se cancela el stream
    }else{
      print('=====================> EL GPS ESTA DESACTIVADO');
    }
  }

  void cancelarSegumiento(){
    _positionSubscription?.cancel();
  }

  Future<bool> verificaEstadoGPS() async{
    return await Location().serviceEnabled();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent event) async* {
    
    if(event is OnVerificaGPS){
      final gps = await this.verificaEstadoGPS();
      final ubicacionActual = gps ? state.existeUbicacion : false;
      yield state.copyWith(gpsActivo: gps, existeUbicacion: ubicacionActual);
    }else if(event is OnGPSDesactivado){
      yield state.copyWith(gpsActivo: false, existeUbicacion: false);
    }else if(event is OnIniciarSeguimiento){
      this.iniciarSeguimiento();
      yield state.copyWith(gpsActivo: true);
    }else if(event is OnSeguirUbicacion){
      yield state.copyWith(siguiendo: !state.siguiendo);
    }else if(event is OnUbicacionCambio){
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion
      );
    }
  }
  
}