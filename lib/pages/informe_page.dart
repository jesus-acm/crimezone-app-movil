import 'package:flutter/material.dart';
import 'package:crimezone_app/global/style.dart';
import 'package:crimezone_app/widgets/estadisticas_crimen.dart';
import 'package:crimezone_app/widgets/informe_grafica.dart';

import 'package:provider/provider.dart';
import 'package:crimezone_app/services/informe_service.dart';


class InformePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final informeService = Provider.of<InformeService>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Informe delictivo', style: TextStyle(fontSize: 22),),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          _opcionesCrimen(context),
          SliverPadding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Colonias con mayor índice delictivo registradas',
                style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 5.0),
            sliver: SliverToBoxAdapter(
              child: EstadisticasCrimen(informeService.crimenes),
            ),
          ),
          _opcionesTiempo(context),
          SliverPadding(
            padding: EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(
              child: InformeGrafica(informeService.valoresGrafica(), informeService.opTiempo),
            ),
          ),
        ],
      ),
   );
  }

  SliverPadding _opcionesCrimen(BuildContext context){
    const opciones = ['Peatón' ,'Transporte público'];
    return SliverPadding(
      padding: EdgeInsets.only(top:20.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: opciones.length,
          child: Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(25.0)
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0)
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: opciones.map((opcion) => Text('${ opcion }', style: Style.titulosStyle)).toList(),
              onTap: (index){
                final informeService = Provider.of<InformeService>(context, listen: false);
                informeService.cambiarTipo(opciones[index]);
              },
            ),
          ),
        ),
      ),
    );
  }


  _opcionesTiempo(BuildContext context){
    final opcionesTiempo = ['Global', 'Últimos 2 meses'];

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: opcionesTiempo.length,
          child: TabBar(
            tabs: opcionesTiempo.map((opcion) => Text(opcion, style: Style.titulosStyle)).toList(),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.transparent,
            onTap: (index){
              final informeService = Provider.of<InformeService>(context, listen: false);
              informeService.opcionTiempo(opcionesTiempo[index]);
            },
          )
        ),
      ),
    );
  }
}