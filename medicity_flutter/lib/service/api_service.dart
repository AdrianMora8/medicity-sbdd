import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicity_flutter/models/consulta_general.dart';
import 'package:medicity_flutter/models/diagnostico.dart';
import 'package:medicity_flutter/models/doctor.dart';
import 'package:medicity_flutter/models/paciente.dart';
import 'package:medicity_flutter/models/cita.dart';

class ApiService {
  // Cambia esta IP cuando tengas la real
  static const String baseUrl = 'http://localhost:5086/api/medicity/distribuida';

  Future<List<ConsultaGeneral>> getConsultaGeneral() async {
    final response = await http.get(Uri.parse('$baseUrl/view'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ConsultaGeneral.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar consultas');
    }
  }

  Future<List<Doctor>> getDoctores() async {
    final response = await http.get(Uri.parse('$baseUrl/doctores'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Doctor.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar doctores');
    }
  }

  Future<List<Diagnostico>> getDiagnosticos() async {
    final response = await http.get(Uri.parse('$baseUrl/diagnosticos'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Diagnostico.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar diagnosticos');
    }
  }

  Future<List<Paciente>> getPacientes() async {
    final response = await http.get(Uri.parse('$baseUrl/pacientes'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Paciente.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar pacientes');
    }
  }

  Future<List<Cita>> getCitas() async {
    final response = await http.get(Uri.parse('$baseUrl/citas'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Cita.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar citas');
    }
  }

  Future<String> crearDoctor(String nombre, int idEspecialidad, int idCiudad) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sp_doctor'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'idEspecialidad': idEspecialidad,
        'idCiudad': idCiudad,
      }),
    );

    return _mensaje(response);
  }

  Future<String> actualizarDoctor(
    int id,
    String nombre,
    int idEspecialidad,
    int idCiudad,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/doctor/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'idEspecialidad': idEspecialidad,
        'idCiudad': idCiudad,
      }),
    );

    return _mensaje(response);
  }

  Future<String> crearDiagnostico(
    int idCita,
    String nombre,
    String descripcion,
    String tratamiento,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sp_diagnostico'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idCita': idCita,
        'nombre': nombre,
        'descripcion': descripcion,
        'tratamiento': tratamiento,
      }),
    );

    return _mensaje(response);
  }

  Future<String> actualizarCita(
    int id,
    int idPaciente,
    int idDoctor,
    String fechaHora,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idPaciente': idPaciente,
        'idDoctor': idDoctor,
        'fechaHora': fechaHora,
      }),
    );

    return _mensaje(response);
  }

  String _mensaje(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['mensaje'] != null) {
        return body['mensaje'].toString();
      }
    } catch (_) {}

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return 'Listo';
    }
    return 'Error ${response.statusCode}: ${response.body}';
  }
}
