import 'package:flutter/material.dart';
import 'package:medicity_flutter/models/diagnostico.dart';
import 'package:medicity_flutter/models/util.dart';
import 'package:medicity_flutter/page/campos.dart';
import 'package:medicity_flutter/service/api_service.dart';

class DiagnosticosPage extends StatefulWidget {
  const DiagnosticosPage({super.key});

  @override
  State<DiagnosticosPage> createState() => _DiagnosticosPageState();
}

class _DiagnosticosPageState extends State<DiagnosticosPage> {
  final api = ApiService();
  late Future<List<Diagnostico>> future;

  @override
  void initState() {
    super.initState();
    future = api.getDiagnosticos();
  }

  void _cargar() {
    setState(() {
      future = api.getDiagnosticos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnósticos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiagnosticoFormPage()),
          ).then((_) => _cargar());
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: FutureBuilder<List<Diagnostico>>(
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
            return const Center(child: Text('No hay diagnósticos'));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.diagnostico,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Paciente: ${item.paciente}'),
                      Text('Fecha: ${fechaBonita(item.fechaHora)}'),
                      const SizedBox(height: 8),
                      Text(item.descripcion),
                      Text('Tratamiento: ${item.tratamiento}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DiagnosticoFormPage extends StatefulWidget {
  const DiagnosticoFormPage({super.key});

  @override
  State<DiagnosticoFormPage> createState() => _DiagnosticoFormPageState();
}

class _DiagnosticoFormPageState extends State<DiagnosticoFormPage> {
  final api = ApiService();
  final nombre = TextEditingController();
  final descripcion = TextEditingController();
  final tratamiento = TextEditingController();
  Map<int, String> citas = {};
  int? idCita;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    api.getConsultaGeneral().then((lista) {
      setState(() {
        for (final c in lista) {
          citas[c.idCita] = '${c.paciente}  •  ${fechaBonita(c.fechaHora)}';
        }
        cargando = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo diagnóstico')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                comboId(
                  label: 'Cita',
                  valor: idCita,
                  opciones: citas,
                  alCambiar: (v) => setState(() => idCita = v),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nombre,
                  decoration: campo('Nombre'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descripcion,
                  decoration: campo('Descripción'),
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: tratamiento,
                  decoration: campo('Tratamiento'),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                botonGuardar('Registrar', () async {
                  if (idCita == null) return;

                  final msg = await api.crearDiagnostico(
                    idCita!,
                    nombre.text,
                    descripcion.text,
                    tratamiento.text,
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
