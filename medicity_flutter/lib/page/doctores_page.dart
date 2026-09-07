import 'package:flutter/material.dart';
import 'package:medicity_flutter/models/doctor.dart';
import 'package:medicity_flutter/page/campos.dart';
import 'package:medicity_flutter/service/api_service.dart';

class DoctoresPage extends StatefulWidget {
  const DoctoresPage({super.key});

  @override
  State<DoctoresPage> createState() => _DoctoresPageState();
}

class _DoctoresPageState extends State<DoctoresPage> {
  final api = ApiService();
  late Future<List<Doctor>> future;

  @override
  void initState() {
    super.initState();
    future = api.getDoctores();
  }

  void _cargar() {
    setState(() {
      future = api.getDoctores();
    });
  }

  void _abrirFormulario([Doctor? doctor]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DoctorFormPage(doctor: doctor)),
    ).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctores')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: FutureBuilder<List<Doctor>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(child: Text('No hay doctores'));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return ListTile(
                title: Text(item.doctor),
                subtitle: Text('${item.especialidad}  •  ${item.ciudad}'),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _abrirFormulario(item),
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorFormPage extends StatefulWidget {
  final Doctor? doctor;

  const DoctorFormPage({super.key, this.doctor});

  @override
  State<DoctorFormPage> createState() => _DoctorFormPageState();
}

class _DoctorFormPageState extends State<DoctorFormPage> {
  final api = ApiService();
  final nombre = TextEditingController();
  Map<int, String> especialidades = {};
  Map<int, String> ciudades = {};
  int? idEspecialidad;
  int? idCiudad;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    if (widget.doctor != null) {
      nombre.text = widget.doctor!.doctor;
      idEspecialidad = widget.doctor!.idEspecialidad;
      idCiudad = widget.doctor!.idCiudad;
    }
    _cargar();
  }

  Future<void> _cargar() async {
    final doctores = await api.getDoctores();
    final consultas = await api.getConsultaGeneral();

    setState(() {
      for (final d in doctores) {
        especialidades[d.idEspecialidad] = d.especialidad;
        ciudades[d.idCiudad] = d.ciudad;
      }
      for (final c in consultas) {
        especialidades[c.idEspecialidad] = c.especialidad;
        ciudades[c.idCiudadPaciente] = c.ciudadPaciente;
        ciudades[c.idCiudadDoctor] = c.ciudadDoctor;
      }
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.doctor != null;

    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar doctor' : 'Nuevo doctor')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: nombre,
                  decoration: campo('Nombre'),
                ),
                const SizedBox(height: 14),
                comboId(
                  label: 'Especialidad',
                  valor: idEspecialidad,
                  opciones: especialidades,
                  alCambiar: (v) => setState(() => idEspecialidad = v),
                ),
                const SizedBox(height: 14),
                comboId(
                  label: 'Ciudad',
                  valor: idCiudad,
                  opciones: ciudades,
                  alCambiar: (v) => setState(() => idCiudad = v),
                ),
                const SizedBox(height: 24),
                botonGuardar(editando ? 'Guardar cambios' : 'Registrar', () async {
                  if (idEspecialidad == null || idCiudad == null) return;

                  final msg = editando
                      ? await api.actualizarDoctor(
                          widget.doctor!.id,
                          nombre.text,
                          idEspecialidad!,
                          idCiudad!,
                        )
                      : await api.crearDoctor(
                          nombre.text,
                          idEspecialidad!,
                          idCiudad!,
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
