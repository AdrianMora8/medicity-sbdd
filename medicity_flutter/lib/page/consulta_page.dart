import 'package:flutter/material.dart';
import 'package:medicity_flutter/models/consulta_general.dart';
import 'package:medicity_flutter/models/util.dart';
import 'package:medicity_flutter/service/api_service.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  final api = ApiService();
  late Future<List<ConsultaGeneral>> future;

  @override
  void initState() {
    super.initState();
    future = api.getConsultaGeneral();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultas')),
      body: FutureBuilder<List<ConsultaGeneral>>(
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
            return const Center(child: Text('No hay consultas'));
          }

          return ListView.builder(
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
                        item.paciente,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Doctor: ${item.doctor}'),
                      Text('Especialidad: ${item.especialidad}'),
                      Text('Ciudad paciente: ${item.ciudadPaciente}'),
                      Text('Fecha: ${fechaBonita(item.fechaHora)}'),
                      const SizedBox(height: 8),
                      Text(
                        'Diagnóstico: ${item.nombreDiagnostico.isEmpty ? item.descripcion : item.nombreDiagnostico}',
                      ),
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
