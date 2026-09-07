import 'package:flutter/material.dart';
import 'package:medicity_flutter/models/cita.dart';
import 'package:medicity_flutter/page/campos.dart';
import 'package:medicity_flutter/service/api_service.dart';

class CitaFormPage extends StatefulWidget {
  final Cita cita;

  const CitaFormPage({super.key, required this.cita});

  @override
  State<CitaFormPage> createState() => _CitaFormPageState();
}

class _CitaFormPageState extends State<CitaFormPage> {
  final api = ApiService();
  Map<int, String> pacientes = {};
  Map<int, String> doctores = {};
  late int idPaciente;
  late int idDoctor;
  late DateTime fecha;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    idPaciente = widget.cita.idPaciente;
    idDoctor = widget.cita.idDoctor;
    fecha = DateTime.tryParse(widget.cita.fechaHora) ?? DateTime.now();
    _cargar();
  }

  Future<void> _cargar() async {
    final listaPacientes = await api.getPacientes();
    final listaDoctores = await api.getDoctores();

    setState(() {
      for (final p in listaPacientes) {
        pacientes[p.id] = p.nombre;
      }
      for (final d in listaDoctores) {
        doctores[d.id] = d.doctor;
      }
      cargando = false;
    });
  }

  String get fechaTexto {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final hora = fecha.hour.toString().padLeft(2, '0');
    final min = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year} $hora:$min';
  }

  Future<void> _elegirFecha() async {
    final dia = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDate: fecha,
    );
    if (dia == null || !mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fecha),
    );
    if (hora == null || !mounted) return;

    setState(() {
      fecha = DateTime(dia.year, dia.month, dia.day, hora.hour, hora.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar cita')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                comboId(
                  label: 'Paciente',
                  valor: idPaciente,
                  opciones: pacientes,
                  alCambiar: (v) {
                    if (v != null) setState(() => idPaciente = v);
                  },
                ),
                const SizedBox(height: 14),
                comboId(
                  label: 'Doctor',
                  valor: idDoctor,
                  opciones: doctores,
                  alCambiar: (v) {
                    if (v != null) setState(() => idDoctor = v);
                  },
                ),
                const SizedBox(height: 14),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha y hora'),
                  subtitle: Text(fechaTexto),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: _elegirFecha,
                ),
                const SizedBox(height: 24),
                botonGuardar('Guardar cambios', () async {
                  final fechaApi =
                      '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}T${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}:00';

                  final msg = await api.actualizarCita(
                    widget.cita.id,
                    idPaciente,
                    idDoctor,
                    fechaApi,
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  Navigator.pop(context);
                }),
              ],
            ),
    );
  }
}
