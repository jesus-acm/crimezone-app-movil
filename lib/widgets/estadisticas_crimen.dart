import 'package:crimezone_app/models/crimen.dart';
import 'package:crimezone_app/services/db_service.dart';
import 'package:flutter/material.dart';

class EstadisticasCrimen extends StatelessWidget {
  final List<Crimen> listaCrimenes;
  
  EstadisticasCrimen(this.listaCrimenes);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final coloresTarjetas = <Color>[
      Colors.red,
      Colors.orange,
      Colors.yellow[700],
      Colors.green,
      Colors.blueGrey,
      Colors.purple
    ];

    final dbService = new DbService();
    final datosTop = dbService.crimenesPeaton.topColonias(6, listaCrimenes: listaCrimenes);

    int indexTarjeta = 0;
    final datos = datosTop.keys.toList();
    final tamDatos = datos.length;
    for(int i = 0; i <= (6 - tamDatos); i++){
      datos.add('');
    }

    return Container(
      height: size.height * 0.25,
      child: Column(
        children: [
          Flexible(
            child: Row(
              children: [
                ...datos.sublist(0, 3).map(
                  (dato) => (dato != '')
                  ? _tarjeta(titulo: dato, 
                    total: '${ datosTop[dato] }', 
                    color: coloresTarjetas[indexTarjeta++]
                  ) : _tarjeta(color: coloresTarjetas[indexTarjeta++])
                ).toList()
              ]
            )
          ),
          Flexible(
            child: Row(
              children: [
                ...datos.sublist(3, 6).map(
                  (dato) => (dato != '')
                  ? _tarjeta(titulo: dato, 
                    total: '${ datosTop[dato] }', 
                    color: coloresTarjetas[indexTarjeta++]
                  ) : _tarjeta(color: coloresTarjetas[indexTarjeta++])
                ).toList()
              ]
            )
          ),
        ],
      ),
    );
  }


  Expanded _tarjeta({String titulo = 'No hay registro', String total = '', Color color}) {
    titulo = titulo.toLowerCase();
    final partTitulo1 = titulo.substring(0,1).toUpperCase();
    final partTitulo2 = titulo.substring(1);
    titulo = partTitulo1 + partTitulo2;

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600),
            ),
            Text(total,
              style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}