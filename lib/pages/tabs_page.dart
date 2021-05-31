import 'package:crimezone_app/bloc/mapa/mapa_bloc.dart';
import 'package:crimezone_app/services/informe_service.dart';
import 'package:crimezone_app/services/navegacion_bar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:crimezone_app/pages/informe_page.dart';
import 'package:crimezone_app/pages/mapa_page.dart';
import 'package:crimezone_app/pages/mas_page.dart';


class TabsPage extends StatefulWidget {

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => InformeService()),
        ChangeNotifierProvider(create: ( _ ) => NavegacionBarService())
      ],
      child: Scaffold(
        body: _Paginas(),
       bottomNavigationBar: _Navegacion(),
   ),
    );
  }
}


class _Paginas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionFinal = Provider.of<NavegacionBarService>(context, listen: false);

    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: navegacionFinal.pageController,
      children: [
        InformePage(),
        MapaPage(context),
        MasPage(),
      ],
    );
  }
}


class _Navegacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final navegacionModel = Provider.of<NavegacionBarService>(context);

    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      onTap: (i){
        navegacionModel.paginaActual = i;
        
        if(i != 1){
          final mapaBloc = BlocProvider.of<MapaBloc>(context);
          mapaBloc.add(OnBorrarMarkers());
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: 'Informe delictivo'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Mas'),
      ]
    );
  }
}