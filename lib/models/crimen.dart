class Crimen {
  final int id;
  final String categoria;
  final DateTime fecha;
  final String nombreCrimen;
  final String colonia;
  final double long;
  final double lat;
  final int idCluster;
  final String color;

  Crimen({
    this.id,
    this.categoria, 
    this.fecha, 
    this.nombreCrimen,
    this.colonia, 
    this.long, 
    this.lat, 
    this.idCluster,
    this.color
  });

  @override
  String toString() {
  return 'Instance of Crimen: ${ this.categoria }';
   }
}