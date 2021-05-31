import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crimezone_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:crimezone_app/services/db_service.dart';
import 'package:crimezone_app/bloc/mapa/mapa_bloc.dart';

import 'package:crimezone_app/widgets/botones_categorias.dart';

class BotonesMapa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbService = new DbService();
    final crimenesPeaton = dbService.crimenesPeaton;
    final crimenesTransporte = dbService.crimenesTransporte;

    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    mapaBloc.add(OnDbLista(
      crimenesPeaton: crimenesPeaton.crimenesAntesUltimaFecha(
          meses: 3, clustersRuido: false),
      crimenesTransporte: crimenesTransporte.crimenesAntesUltimaFecha(
          meses: 3, clustersRuido: false),
    ));

    return BlocBuilder<MapaBloc, MapaState>(
      builder: ( _, state) {
        if(state.visualizando){
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[300],
                maxRadius: 25,
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    final mapaBloc = BlocProvider.of<MapaBloc>(context);
                    mapaBloc.add(OnDesactivarVisualizando());
                  }),
              ),
              SizedBox(height: 10),
              CircleAvatar(
                backgroundColor: Colors.red,
                maxRadius: 25,
                child: IconButton(
                  icon: Icon(Icons.cancel_outlined, color: Colors.white),
                  onPressed: () {
                    final mapaBloc = BlocProvider.of<MapaBloc>(context);
                    mapaBloc.add(OnDesactivarVisualizando());
                    mapaBloc.add(OnDesactivarManual());
                  }),
              ),
              SizedBox(height: 10)
            ]
          );
        }else{
          return Stack(
            children: [
              _botonUbicacionManual(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  state.manual
                    ? Container(width: 0)
                    : _botonUbicacion(),
                  SizedBox(height: 10),
                  BotonesCategorias(
                    onPressedPeaton: () {
                      final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context,listen: false);
                      if(miUbicacionBloc.state.existeUbicacion){
                        mapaBloc.add(OnOpcionPeaton(miUbicacionBloc.state.ubicacion));
                      }
                    },
                    onPressedTransporte: () {
                      final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context,listen: false);
                      if(miUbicacionBloc.state.existeUbicacion){
                        mapaBloc.add(OnOpcionTransporte(miUbicacionBloc.state.ubicacion));
                      }
                    },
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _botonUbicacionManual() {
    return Positioned(
      top: 50,
      child: BlocBuilder<MapaBloc, MapaState>(
        builder: (context, state) {
          return CircleAvatar(
            backgroundColor: state.manual ? Colors.blue[300] : Colors.blue[100],
            maxRadius: 25,
            child: IconButton(
                icon: Icon(
                    !state.manual ? Icons.live_help_outlined : Icons.arrow_back,
                    color: state.manual ? Colors.white : Colors.black87),
                onPressed: () {
                  final mapaBloc = BlocProvider.of<MapaBloc>(context);
                  mapaBloc.add(
                    !state.manual ? OnActivarManual() : OnDesactivarManual()
                  );
                }),
          );
        },
      ),
    );
  }

  Widget _botonUbicacion() {
    return BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
      builder: (BuildContext context, state) {
        if (!state.gpsActivo) {
          return CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
                icon: Icon(Icons.location_disabled, color: Colors.red),
                onPressed: () async {
                  final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);
                  bool gpsActivo = await miUbicacionBloc.verificaEstadoGPS();
                  if (!gpsActivo) {
                    gpsActivo = await Location().requestService();
                  }
                  miUbicacionBloc.add(OnVerificaGPS());
                  miUbicacionBloc.iniciarSeguimiento(gps: gpsActivo);
                }),
          );
        } else {
          return CircleAvatar(
            backgroundColor: state.siguiendo ? Colors.blue[300] : Colors.white,
            maxRadius: 25,
            child: IconButton(
                icon: Icon(Icons.my_location,
                    color: state.siguiendo ? Colors.white : Colors.black87),
                onPressed: () {
                  final miUbicacionBloc =
                      BlocProvider.of<MiUbicacionBloc>(context, listen: false);
                  miUbicacionBloc.add(OnSeguirUbicacion());
                  if (!state.siguiendo) {
                    final mapaBloc = BlocProvider.of<MapaBloc>(context);
                    mapaBloc.moverCamara(miUbicacionBloc.state.ubicacion);
                  }
                }),
          );
        }
      },
    );
  }
}
