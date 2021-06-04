import 'dart:io';
import 'dart:convert';
import 'package:crimezone_app/models/crimen.dart';
import 'package:crimezone_app/models/crimenes.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DbService {
  DbService._privado();
  static final DbService _instancia = new DbService._privado();
  factory DbService(){
    return _instancia;
  }

  String _dbPeaton = 'clusters_GAM';
  String _dbTransportePublico = 'clusters_GAM_transporte_publico';
  String _dbVersiones = 'versiones';

  Crimenes crimenesPeaton = new Crimenes(); 
  Crimenes crimenesTransporte = new Crimenes(); 

  // Obtenemos la direccion local de la DB
  Future<File> _archivoLocal(String nombreArchivo) async {
    final directorio = await getApplicationDocumentsDirectory();
    final path = directorio.path;
    return File('$path/$nombreArchivo.txt');
  }

  Future<bool> get verficaDb async {
    final directorio = await getApplicationDocumentsDirectory();
    final path = directorio.path;

    final bandera = await Future.wait([
      File('$path/${ this._dbPeaton }.txt').exists(),
      File('$path/${ this._dbTransportePublico }.txt').exists()
    ]);

    return bandera[0] && bandera[1];
  }


  // Transformar string a una lista de crimenes
  Crimenes transformarStringACrimenes(String cadena){
    List<List<dynamic>> datos = CsvToListConverter().convert(cadena, textEndDelimiter: '\n', eol: '\n');
    datos.removeAt(0);
    Crimenes tempCrimenes = new Crimenes();
    
    int val = 0;
    datos.forEach((dato){
      Crimen crimen = new Crimen(
        id: val++,
        categoria:  dato[0],
        fecha: DateTime.parse(dato[1]),
        nombreCrimen: dato[2],
        colonia: dato[3],
        long: dato[4],
        lat: dato[5],
        idCluster: dato[6],
        color: dato[7]
      );
      if(crimen.idCluster != -1){
        tempCrimenes.agrupados.add(crimen);
      }else{
        tempCrimenes.ruido.add(crimen);
      }
      tempCrimenes.ultimaFecha = crimen.fecha;
    });
    
    return tempCrimenes;
  }


  Future descargarDB() async {
    try {
      // final resp = await http.get('https://crime-zone.herokuapp.com/api/file');
      final peticiones = await Future.wait([
        http.get('https://crime-zone.herokuapp.com/api/file/${ this._dbPeaton }'),
        http.get('https://crime-zone.herokuapp.com/api/file/${ this._dbTransportePublico }')
      ]);
      // final peticiones = await Future.wait([
      //   http.get('${ Enviroment.apiUrl }/file/${ this._dbPeaton }'),
      //   http.get('${ Enviroment.apiUrl }/file/${ this._dbTransportePublico }')
      // ]);

      this.crimenesPeaton.setCrimenes(transformarStringACrimenes(peticiones[0].body));
      this.crimenesTransporte.setCrimenes(transformarStringACrimenes(peticiones[1].body));
      
      final archivos = await Future.wait([
        _archivoLocal(this._dbPeaton),
        _archivoLocal(this._dbTransportePublico),
        _archivoLocal(this._dbVersiones)
      ]);

      final versiones = {
        'peaton': peticiones[0].headers['x-version'],
        'transporte': peticiones[1].headers['x-version']
      };
      
      await Future.wait([
        archivos[0].writeAsString(peticiones[0].body),//Archivo peaton
        archivos[1].writeAsString(peticiones[1].body),//Archivo transporte
        archivos[2].writeAsString(jsonEncode(versiones))
      ]);
      
      // print(jsonDecode(casteo));
      print('Crimenes descargados');
    } catch (error) {
      print('DbService descargarDB: $error');
    }
  }

  Future cargarDB() async {
    try {
      final archivos = await Future.wait([
        this._archivoLocal(this._dbPeaton),
        this._archivoLocal(this._dbTransportePublico)
      ]);

      final contenidos = await Future.wait([
        archivos[0].readAsString(),
        archivos[1].readAsString()
      ]);

      this.crimenesPeaton.setCrimenes(transformarStringACrimenes(contenidos[0]));
      this.crimenesTransporte.setCrimenes(transformarStringACrimenes(contenidos[1]));

    
    } catch (error) {
      print('DbService cargarDB: $error');
    }
  }

  Future<dynamic> verificaActualizacion() async{
    try {
      final archivoVersiones = await _archivoLocal(this._dbVersiones);
      String contenido = await archivoVersiones.readAsString();
      
      final resp = await http.post('https://crime-zone.herokuapp.com/api/file/version', 
        body: jsonDecode(contenido),
      );

      final respBody = jsonDecode(resp.body);

      return respBody;
    } catch (error) {
      print('DbService verificaActualizacion: $error');
      return {"ok": false};
    }
  }


  Future versionesActuales() async{
    final archivoVersiones = await _archivoLocal(this._dbVersiones);
    String contenido = await archivoVersiones.readAsString();
    final versiones = jsonDecode(contenido);
    return versiones;
  }
}