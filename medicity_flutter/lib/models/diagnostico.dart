import 'package:medicity_flutter/models/util.dart';

class Diagnostico {
  final int id;
  final int idCita;
  final String diagnostico;
  final String descripcion;
  final String tratamiento;
  final int idPaciente;
  final String paciente;
  final String fechaHora;

  Diagnostico({
    required this.id,
    required this.idCita,
    required this.diagnostico,
    required this.descripcion,
    required this.tratamiento,
    required this.idPaciente,
    required this.paciente,
    required this.fechaHora,
  });

  factory Diagnostico.fromJson(Map<String, dynamic> json) {
    final map = minusculas(json);
    return Diagnostico(
      id: asInt(map['id']),
      idCita: asInt(map['id_cita']),
      diagnostico: map['diagnostico']?.toString() ?? '',
      descripcion: map['descripcion']?.toString() ?? '',
      tratamiento: map['tratamiento']?.toString() ?? '',
      idPaciente: asInt(map['id_paciente']),
      paciente: map['paciente']?.toString() ?? '',
      fechaHora: map['fechahora']?.toString() ?? '',
    );
  }
}
