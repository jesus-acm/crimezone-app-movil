import 'package:crimezone_app/models/crimen.dart';
import 'package:crimezone_app/services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:simple_moment/simple_moment.dart';

class InformeService with ChangeNotifier {

  final int _divisionesGraficaUltimosMeses = 15;

  List<Crimen> _crimenes = DbService().crimenesPeaton.crimenesAntesUltimaFecha(anios: 3);
  String _tipo = 'Peatón';
  int _anios = 3;
  int _meses = 0;

  void cambiarTipo(String tipo){
    if(tipo == 'Peatón'){
      this._tipo = 'Peatón';
      this._crimenes = DbService().crimenesPeaton.crimenesAntesUltimaFecha(anios: this._anios, meses: this._meses);
    }else{
      this._tipo = 'Transporte público';
      this._crimenes = DbService().crimenesTransporte.crimenesAntesUltimaFecha(anios: this._anios, meses: this._meses);
    }
    notifyListeners();
  }

  void opcionTiempo(String tiempo){
    if(tiempo == 'Global'){
      this._meses = 0;
      this._anios = 3;
    }else{
      this._meses = 2;
      this._anios = 0;
    }
    cambiarTipo(this._tipo);
  }


  List<Crimen> get crimenes => this._crimenes;

  String get opTiempo => (this._meses == 0) ? 'Global' : 'Últimos 2 meses';


  Map<String, int> _valoresGraficaGlobal(){
    final mapa = new Map<String, int>();
    const meses = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];
    // const meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    meses.forEach((mes) => mapa[mes] = 0);
    
    crimenes.forEach((crimen){
      mapa[meses[Moment.fromDate(crimen.fecha).month-1]]++;
    });
    return mapa;
  }


  List<DateTime> _mapaDiasUltimoMes(){
    final listaFechas = new List<DateTime>();
    Moment ultimaFechaDatos = Moment.fromDate((this._tipo == 'Peatón')
      ? DbService().crimenesPeaton.ultimaFecha
      : DbService().crimenesTransporte.ultimaFecha);

    Moment primeraFecha = ultimaFechaDatos.subtract(months: this._meses);

    while(ultimaFechaDatos.compareTo(primeraFecha.date) >= 0){
      listaFechas.add(primeraFecha.date);
      primeraFecha = primeraFecha.add(days: 1);
    }

    return listaFechas;
  }


  String _casteoFechaADiaMes(DateTime fecha){
    const meses = ['ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN', 'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'];

    final dia = (fecha.day < 10) ? '0${ fecha.day }' : '${ fecha.day }';
    final mes = meses[fecha.month - 1];
    return '$dia-$mes';
  }


  Map<String, int> _distribucionUltimoMes(){
    final listaFechas = this._mapaDiasUltimoMes();
    final mapaFechas = new Map<String, int>();
    
    //Aui se pueden poner intervalos
    listaFechas.forEach((dispFecha){
      mapaFechas[this._casteoFechaADiaMes(dispFecha)] = this._crimenes.where((crimen){
        final fecha = crimen.fecha;
        return  (fecha.day == dispFecha.day) && (fecha.month == dispFecha.month) && (fecha.year == dispFecha.year);
      }).length;
    });

    return mapaFechas;
  }

  Map<String, int> _valoresGraficaUltimoMes(){
    Map<String, int> mapaDistribucion = new Map<String, int>();
    
    final distribucion = this._distribucionUltimoMes();
    final diaMes = distribucion.keys.toList();
    final tamanio = diaMes.length;

    int aux = 0;
    String inicioFecha = '';
    String finFecha = '';
    int total = 0;

    for (var i = 0; i < tamanio; i++) {
      if(aux == 0){
        total = distribucion[diaMes[i]];
        inicioFecha = diaMes[i];
      }else if(aux < this._divisionesGraficaUltimosMeses){
        total = total + distribucion[diaMes[i]];
        finFecha = diaMes[i];
      }
      aux++;

      if(aux == this._divisionesGraficaUltimosMeses){
        mapaDistribucion['     $inicioFecha  $finFecha'] = total;
        aux = 0;
        inicioFecha = '';
        finFecha = '';
      }else if((tamanio - 1) == i){
        mapaDistribucion['     $inicioFecha  $finFecha'] = total;
      }
    }

    return mapaDistribucion;
  }


  Map<String, int> valoresGrafica(){
    print('Cantidad crimenes: ${this.crimenes.length}');
    if(this._meses == 0){//Opcion Global seleccionada
      return this._valoresGraficaGlobal();
    }else{
      return this._valoresGraficaUltimoMes();
    }
  }
}