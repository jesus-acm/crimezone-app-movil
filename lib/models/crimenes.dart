import 'package:crimezone_app/models/crimen.dart';
import 'package:simple_moment/simple_moment.dart';

class Crimenes {
  List<Crimen> agrupados;
  List<Crimen> ruido;
  Moment _ultimaFecha;


  Crimenes({
    List<Crimen> agrupados,
    List<Crimen> ruido,
    Moment ultimaFecha
  })
  : this.agrupados = agrupados ?? [], 
  this.ruido = ruido ?? [],
  this._ultimaFecha = ultimaFecha ?? null;


  void setCrimenes(Crimenes crimenes){
    this.agrupados.addAll(crimenes.agrupados);
    this.ruido.addAll(crimenes.ruido);
    final tempFechaCrimenes = crimenes.ultimaFecha;
    final fecha = Moment.fromDate(tempFechaCrimenes);
    this._ultimaFecha = fecha.subtract(
      hours: tempFechaCrimenes.hour, 
      minutes: tempFechaCrimenes.minute,
      seconds: tempFechaCrimenes.second
    );
  } 


  void set ultimaFecha(DateTime fecha){
    if(this._ultimaFecha == null){
      this._ultimaFecha = Moment.fromDate(fecha);
      return ;
    }
    final valor = this._ultimaFecha.compareTo(fecha);
    if(valor <= 0){
      this._ultimaFecha = Moment.fromDate(fecha);
    }
  }


  DateTime get ultimaFecha => this._ultimaFecha.date;


  /**
   *  Si la fecha es 30 de Marzo y se quita un mes, devuelve datos a partir del 1 de Marzo
   *  Si la fecha es 30 de Abril y se quita un mes, devuelve datos a partir del 30 de Marzo
   */
  List<Crimen> crimenesAntesUltimaFecha({int anios = 0, int meses = 0, bool clustersRuido = true}){
    final fechaComparar = this._ultimaFecha.subtract(years: anios, months: meses);
    List<Crimen> auxCrimen = [];
    auxCrimen.addAll(agrupados.where((crimen) => fechaComparar.compareTo(crimen.fecha) <= 0));
    
    if (clustersRuido)
      auxCrimen.addAll(ruido.where((crimen) => fechaComparar.compareTo(crimen.fecha) <= 0));
    
    return auxCrimen;
  }


  Map<String, int> topColonias(int numTop, {List<Crimen> listaCrimenes}){
    final crimenes = listaCrimenes ?? crimenesAntesUltimaFecha(anios: 3);
    Map<String, int> distribucionColonia = new Map<String, int>();
    Map<String, int> distribuciones = new Map<String, int>();
    
    crimenes.forEach((crimen){
      if(distribucionColonia[crimen.colonia] == null){
        distribucionColonia[crimen.colonia] = 0;
      }
      distribucionColonia[crimen.colonia]++; 
    });

    final veces = (distribucionColonia.length < numTop)
      ? distribucionColonia.length
      : numTop;
    
    for(int i = 0; i < veces; i++){
      String auxKey;
      int auxVal = 0;
      
      distribucionColonia.forEach(
        (key, value){
          if(value > auxVal){
            auxVal = value;
            auxKey = key;
          }
        }
      );

      distribucionColonia.remove(auxKey);
      distribuciones[auxKey] = auxVal;
    }
    
    return distribuciones;
  }
}