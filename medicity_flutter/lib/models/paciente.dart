import 'package:medicity_flutter/models/util.dart';

class Paciente {
  final int id;
  final String nombre;
  final String fechaNacimiento;
  final String direccion;
  final int idCiudad;
  final String ciudad;

  Paciente({
    required this.id,
    required this.nombre,
    required this.fechaNacimiento,
    required this.direccion,
    required this.idCiudad,
    required this.ciudad,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    final map = minusculas(json);
    return Paciente(
      id: asInt(map['id']),
      nombre: map['nombre']?.toString() ?? '',
      fechaNacimiento: map['fecha_nacimiento']?.toString() ?? '',
      direccion: map['direccion']?.toString() ?? '',
      idCiudad: asInt(map['id_ciudad']),
      ciudad: map['ciudad']?.toString() ?? '',
    );
  }
}
