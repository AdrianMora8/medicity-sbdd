import 'package:flutter/material.dart';
import 'package:medicity_flutter/models/paciente.dart';
import 'package:medicity_flutter/models/util.dart';
import 'package:medicity_flutter/service/api_service.dart';

class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final api = ApiService();
  late Future<List<Paciente>> future;

  @override
  void initState() {
    super.initState();
    future = api.getPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: FutureBuilder<List<Paciente>>(
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
            return const Center(child: Text('No hay pacientes'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return ListTile(
                title: Text(item.nombre),
                subtitle: Text(
                  '${item.ciudad}  •  ${item.direccion}  •  Nace: ${fechaBonita(item.fechaNacimiento)}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
