import 'package:crimezone_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MiUbicacionBloc>(context).add(OnVerificaGPS());

    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return Center(
              child: Text(snapshot.data),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }
        },
      ),
   );
  }


  Future checkGpsYLocation(BuildContext context) async{
    
    // Permiso Gps
    final permisoGPS = await Permission.location.isGranted;

    if(permisoGPS){
      Navigator.pushReplacementNamed(context, 'tabs');
      return '';
    }else{
      Navigator.pushReplacementNamed(context, 'acceso_gps');
      return 'Es necesario el permiso el GPS';
    }
  }
}