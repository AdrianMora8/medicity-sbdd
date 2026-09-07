import 'package:medicity_flutter/models/util.dart';

class Cita {
  final int id;
  final int idPaciente;
  final String paciente;
  final int idDoctor;
  final String doctor;
  final String fechaHora;

  Cita({
    required this.id,
    required this.idPaciente,
    required this.paciente,
    required this.idDoctor,
    required this.doctor,
    required this.fechaHora,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    final map = minusculas(json);
    return Cita(
      id: asInt(map['id']),
      idPaciente: asInt(map['id_paciente']),
      paciente: map['paciente']?.toString() ?? '',
      idDoctor: asInt(map['id_doctor']),
      doctor: map['doctor']?.toString() ?? '',
      fechaHora: map['fechahora']?.toString() ?? '',
    );
  }
}
