import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InformeGrafica extends StatelessWidget {
  final Map<String, int> mapa;
  final String tipoTiempo;
  InformeGrafica(this.mapa, this.tipoTiempo);

  @override
  Widget build(BuildContext context) {
    final titulos = this.mapa.keys.toList();
    final covidUSADailyNewCases = this.mapa.values.toList();
    
    final copCovid = [...covidUSADailyNewCases];
    copCovid.sort();
    final numMaximoY = copCovid.last;

    final divisiones = numDivisiones(numMaximoY); //Cambiar

    return Container(
      height: (this.tipoTiempo == 'Global') ? 410.0 : 460,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        )
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Cantidad de crímenes total',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: numMaximoY.toDouble(),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    margin: 10.0,
                    showTitles: true,
                    rotateAngle: 90.0,
                    getTextStyles: (value) => TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500
                    ),
                    getTitles: (double value) => value.toInt() < titulos.length
                      ? titulos[value.toInt()]
                      : '',
                  ),
                  leftTitles: SideTitles(
                    interval: divisiones.toDouble(),
                    margin: 10.0,
                    showTitles: true,
                    getTextStyles: (value) => TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500
                    ),
                    getTitles: (value) {
                      if(value == 0){
                        return '0';
                      }else if(value % divisiones == 0){
                        return '${ value.toInt()  }';
                      }
                      return '';
                    },
                  )
                ),
                gridData: FlGridData(
                  horizontalInterval: divisiones.toDouble(),
                  show: true,
                  checkToShowHorizontalLine: (value) => (value % divisiones == 0),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.black12,
                    strokeWidth: 2.0,
                    dashArray: [5]
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: covidUSADailyNewCases
                  .asMap()
                  .map((key, value) => MapEntry(
                      key, 
                      BarChartGroupData(
                        x: key,
                        barRods: [BarChartRodData(y: value.toDouble(), colors: [Colors.red])]
                      )
                    )
                  ).values
                  .toList()
              )
            ),
          )
        ],
      ),
   );
  }

  int numDivisiones(int numero){
    int divisiones = numero ~/ 5;
    double condicion = (numero + 1) / divisiones;

    while (condicion > 6.0){
      divisiones++;
      condicion = (numero + 1) / divisiones;
    };
    return divisiones;
  }
}