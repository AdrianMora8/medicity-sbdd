import 'package:medicity_flutter/models/util.dart';

class ConsultaGeneral {
  final int num;
  final int idCita;
  final int idPaciente;
  final String paciente;
  final String fechaNacimiento;
  final String direccion;
  final int idCiudadPaciente;
  final String ciudadPaciente;
  final int idDoctor;
  final String doctor;
  final int idCiudadDoctor;
  final String ciudadDoctor;
  final int idEspecialidad;
  final String especialidad;
  final String fechaHora;
  final int? idDiagnostico;
  final String nombreDiagnostico;
  final String descripcion;
  final String tratamiento;

  ConsultaGeneral({
    required this.num,
    required this.idCita,
    required this.idPaciente,
    required this.paciente,
    required this.fechaNacimiento,
    required this.direccion,
    required this.idCiudadPaciente,
    required this.ciudadPaciente,
    required this.idDoctor,
    required this.doctor,
    required this.idCiudadDoctor,
    required this.ciudadDoctor,
    required this.idEspecialidad,
    required this.especialidad,
    required this.fechaHora,
    required this.idDiagnostico,
    required this.nombreDiagnostico,
    required this.descripcion,
    required this.tratamiento,
  });

  factory ConsultaGeneral.fromJson(Map<String, dynamic> json) {
    final map = minusculas(json);
    return ConsultaGeneral(
      num: asInt(map['num']),
      idCita: asInt(map['id_cita']),
      idPaciente: asInt(map['id_paciente']),
      paciente: map['paciente']?.toString() ?? '',
      fechaNacimiento: map['fecha_nacimiento']?.toString() ?? '',
      direccion: map['direccion']?.toString() ?? '',
      idCiudadPaciente: asInt(map['id_ciudad_paciente']),
      ciudadPaciente: map['ciudad_paciente']?.toString() ?? '',
      idDoctor: asInt(map['id_doctor']),
      doctor: map['doctor']?.toString() ?? '',
      idCiudadDoctor: asInt(map['id_ciudad_doctor']),
      ciudadDoctor: map['ciudad_doctor']?.toString() ?? '',
      idEspecialidad: asInt(map['id_especialidad']),
      especialidad: map['especialidad']?.toString() ?? '',
      fechaHora: map['fechahora']?.toString() ?? '',
      idDiagnostico: asIntN(map['id_diagnostico']),
      nombreDiagnostico: map['nombre_diagnostico']?.toString() ?? '',
      descripcion: map['descripcion']?.toString() ?? '',
      tratamiento: map['tratamiento']?.toString() ?? '',
    );
  }
}
