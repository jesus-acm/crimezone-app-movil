import 'package:crimezone_app/bloc/mapa/mapa_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UbicacionManual extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
      builder: ( _, state) {
        return !state.manual || state.visualizando
          ? Container()
          : _buildUbicacionManual(context);
      },
    );
  }

  Widget _buildUbicacionManual(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          bottom: 50,
          left: size.width * 0.15,
          child: MaterialButton(
            minWidth: size.width * 0.65,
            child: Text('Ubicar posición', style: TextStyle(fontSize: 16),),
            color: Colors.blue[300],
            textColor: Colors.white,
            shape: StadiumBorder(),
            onPressed: (){
              final mapaBloc = BlocProvider.of<MapaBloc>(context);
              mapaBloc.add(OnNuevaUbicacion(mapaBloc.state.ubicacionMapa));
              mapaBloc.add(OnActivarVisualizando());
            },
          )
        ),
        Center(
          child: Transform.translate(
            offset: Offset(0, -12),
            child: Icon(Icons.location_on, color: Colors.blue[300], size: 50)
          )
        )
      ]
    );
  }
}