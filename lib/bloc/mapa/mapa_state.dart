part of 'mapa_bloc.dart';

@immutable
class MapaState{
  final bool mapaListo;
  final bool dbLista;
  final bool peaton;
  final bool transporte;
  final bool manual;
  final bool visualizando;
  final LatLng ubicacionMapa;
  final List<Crimen> crimenesPeaton;
  final List<Crimen> crimenesTransporte;

  final Map<String, Marker> marcadores;

  MapaState({
    this.mapaListo = false,
    this.dbLista = false,
    this.peaton = false,
    this.transporte= false,
    this.manual = false,
    this.visualizando = false,
    this.ubicacionMapa,
    this.crimenesPeaton = const [],
    this.crimenesTransporte= const [],
    Map<String, Marker> marcadores
  }): this.marcadores = marcadores ?? new Map();

  MapaState copyWith({
    bool mapaListo,
    bool dbLista,
    bool peaton,
    bool transporte,
    bool manual,
    bool visualizando,
    LatLng ubicacionMapa,
    List<Crimen> crimenesPeaton,
    List<Crimen> crimenesTransporte,
    Map<String, Marker> marcadores
  }) => MapaState(
    mapaListo: mapaListo ?? this.mapaListo,
    dbLista: dbLista ?? this.dbLista,
    peaton: peaton ?? this.peaton,
    transporte: transporte ?? this.transporte,
    manual: manual ?? this.manual,
    visualizando: visualizando ?? this.visualizando,
    ubicacionMapa: ubicacionMapa ?? this.ubicacionMapa,
    crimenesPeaton: crimenesPeaton ?? this.crimenesPeaton,
    crimenesTransporte: crimenesTransporte ?? this.crimenesTransporte,
    marcadores: marcadores ?? this.marcadores,
  );
}
