import 'package:crimezone_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:crimezone_app/pages/acceso_gps.dart';
import 'package:crimezone_app/pages/loading_page.dart';
import 'package:crimezone_app/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:crimezone_app/bloc/mapa/mapa_bloc.dart';

import 'package:crimezone_app/pages/tabs_page.dart';
 
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  final dbService = new DbService();
  final existeDb = await dbService.verficaDb;
  
  if(existeDb){
    await dbService.cargarDB();
  }
  else{
    await dbService.descargarDB();
  }
  
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ( _ ) => MapaBloc()),
        BlocProvider(create: ( _ ) => MiUbicacionBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LoadingPage(),
        routes: {
          'acceso_gps': (_) => AccesoGpsPage(),
          'tabs': (_) => TabsPage(),
          'loading': (_) => LoadingPage()
        },
      ),
    );
  }
}