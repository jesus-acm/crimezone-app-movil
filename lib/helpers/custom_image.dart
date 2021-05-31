import 'package:flutter/material.dart' show ImageConfiguration;
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> _marcador(String ruta) async{
  return await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(
      devicePixelRatio: 2.5,
    ), 
    ruta
  );
}

Future<BitmapDescriptor> marcadorRojo() async => await _marcador('assets/punto-rojo.png');

Future<BitmapDescriptor> marcadorNaranja() async => await _marcador('assets/punto-naranja.png');

Future<BitmapDescriptor> marcadorVerde() async => await _marcador('assets/punto-verde.png');

Future<BitmapDescriptor> marcadorUbicacion() async => await _marcador('assets/marcador.png');

Future<Map<String,BitmapDescriptor>> mapaMarcadores() async{
  final marcadores = await Future.wait([
    marcadorUbicacion(),
    marcadorRojo(),
    marcadorNaranja(),
    marcadorVerde()
  ]);

  Map<String,BitmapDescriptor> mapa = new Map();

  mapa['marcador'] = marcadores[0];
  mapa['Rojo'] = marcadores[1];
  mapa['Naranja'] = marcadores[2];
  mapa['Verde'] = marcadores[3];

  return mapa;
}