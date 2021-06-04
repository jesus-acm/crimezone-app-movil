import 'package:crimezone_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:crimezone_app/widgets/ubicacion_manual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:crimezone_app/services/navegacion_bar_service.dart';
import 'package:crimezone_app/bloc/mapa/mapa_bloc.dart';

import 'package:crimezone_app/widgets/botones_mapa.dart';

class MapaPage extends StatefulWidget {
  final BuildContext context;

  const MapaPage(this.context);
  @override
  _MapaPageState createState() => _MapaPageState(context);
}

class _MapaPageState extends State<MapaPage>{
  final BuildContext context;

  _MapaPageState(this.context);

  @override
  void initState() { 
    super.initState();
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
  }
  
  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSegumiento();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
        builder: ( _ , state) {
          return Stack(
            children: [
              this._crearMapa(state),
              UbicacionManual()
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: BotonesMapa()
    );
  }


  Widget _crearMapa(MiUbicacionState stateUbicacion) {

    final cameraPosition = new CameraPosition(
      target: LatLng(19.501823, -99.149291),
      zoom: 15.5
    );
    
    if(stateUbicacion.existeUbicacion && stateUbicacion.siguiendo){
      final mapaBloc = BlocProvider.of<MapaBloc>(context);
      if(!mapaBloc.state.manual)
        mapaBloc.add(OnNuevaUbicacion(stateUbicacion.ubicacion));
    }else if(!stateUbicacion.gpsActivo){
      final mapaBloc = BlocProvider.of<MapaBloc>(context);
      mapaBloc.add(OnBorrarMarkers());
    }

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, state) {
        if(!state.dbLista ) return Center(child: Text('Cargando datos...'));

        final navegacionBarService = Provider.of<NavegacionBarService>(context);
        if(navegacionBarService.paginaActual != 1) return Container();

        final mapaBloc = BlocProvider.of<MapaBloc>(context);
        
        return GoogleMap(
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          initialCameraPosition: cameraPosition,
          onMapCreated: mapaBloc.initMapa,
          markers: state.marcadores.values.toSet(),
          onCameraMove: (cameraPosition){
            mapaBloc.add(OnMovioMapa(cameraPosition.target));
          },
        );
      },
    );
  }
}
