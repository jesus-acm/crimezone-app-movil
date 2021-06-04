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