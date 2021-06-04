import 'package:crimezone_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:crimezone_app/helpers/mostrar_alerta.dart';
import 'package:flutter/material.dart';

import 'package:crimezone_app/services/db_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class MasPage extends StatefulWidget {
  @override
  _MasPageState createState() => _MasPageState();
}

class _MasPageState extends State<MasPage> with WidgetsBindingObserver{
  bool actualizacion = false;
  @override
  void initState() { 
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);
      miUbicacionBloc.add(OnVerificaGPS());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.0,
              child: Center(
                child: FlutterLogo(size: 300),
              ),
            ),
            Divider(height: 10.0),
            _ubicacion(),
            Divider(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.cloud_download_outlined),
                Expanded(
                  child: Text(
                    '  Actualizar datos',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
                FutureBuilder(
                  future: DbService().verificaActualizacion(),
                  initialData: {"ok": false},
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    final bandera = !snapshot.data["ok"] 
                      ? false 
                      : snapshot.data["peaton"] || snapshot.data["transporte"];

                    return GestureDetector(
                      child: Icon(
                        Icons.download_rounded, 
                        color: !bandera ? Colors.grey : Colors.blue[300]
                      ),
                      onTap: !bandera
                      ? (){}
                      : () async {
                        final dbService = new DbService();
                        await dbService.descargarDB();
                        mostrarAlerta(context, 'Descargando datos');
                        await Future.delayed(Duration(milliseconds: 1800));
                        Navigator.of(context).pushReplacementNamed('loading');
                      },
                    );
                  },
                ),
                SizedBox(width: 18.0)
              ],
            ),
            Divider(height: 25.0),
            _versiones()
          ],
        ),
      ),
    );
  }

  Widget _ubicacion() {
    return BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.my_location),
            Expanded(
              child: Text(
                '  Ubicación',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            Switch(
              activeColor: Colors.blue[300],
              value: state.gpsActivo,
              onChanged: (value) async {
                final miUbicacionBloc = BlocProvider.of<MiUbicacionBloc>(context);
                bool gps = await miUbicacionBloc.verificaEstadoGPS();

                if (!gps) {
                  await Location().requestService();
                  miUbicacionBloc.add(OnVerificaGPS());
                } else {
                  await Geolocator.openLocationSettings();
                }
              }
            ),
          ],
        );
      },
    );
  }

  Widget _versiones() {
    return FutureBuilder(
      future: DbService().versionesActuales(),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Container();

        final fechaPeaton = DateTime.fromMillisecondsSinceEpoch(
            int.parse(snapshot.data['peaton']));
        final fechaTransporte = DateTime.fromMillisecondsSinceEpoch(
            int.parse(snapshot.data['transporte']));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined),
                Text('  Versión de datos', style: TextStyle(fontSize: 17.0)),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 10.0),
              child: Text(
                'Peatón: ${fechaPeaton.toString()?.split(' ')?.first}',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 8.0),
              child: Text(
                'Transporte público: ${fechaTransporte.toString()?.split(' ')?.first}',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17.0),
              ),
            )
          ],
        );
      },
    );
  }
}
