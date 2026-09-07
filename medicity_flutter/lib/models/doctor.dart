import 'package:medicity_flutter/models/util.dart';

class Doctor {
  final int id;
  final String doctor;
  final int idEspecialidad;
  final String especialidad;
  final int idCiudad;
  final String ciudad;

  Doctor({
    required this.id,
    required this.doctor,
    required this.idEspecialidad,
    required this.especialidad,
    required this.idCiudad,
    required this.ciudad,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    final map = minusculas(json);
    return Doctor(
      id: asInt(map['id']),
      doctor: map['doctor']?.toString() ?? '',
      idEspecialidad: asInt(map['id_especialidad']),
      especialidad: map['especialidad']?.toString() ?? '',
      idCiudad: asInt(map['id_ciudad']),
      ciudad: map['ciudad']?.toString() ?? '',
    );
  }
}
