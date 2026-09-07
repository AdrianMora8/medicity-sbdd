import 'package:flutter/material.dart';
import 'package:medicity_flutter/models/cita.dart';
import 'package:medicity_flutter/models/util.dart';
import 'package:medicity_flutter/page/cita_page.dart';
import 'package:medicity_flutter/service/api_service.dart';

class CitasMedicasPage extends StatefulWidget {
  const CitasMedicasPage({super.key});

  @override
  State<CitasMedicasPage> createState() => _CitasMedicasPageState();
}

class _CitasMedicasPageState extends State<CitasMedicasPage> {
  final api = ApiService();
  late Future<List<Cita>> future;

  @override
  void initState() {
    super.initState();
    future = api.getCitas();
  }

  void _cargar() {
    setState(() {
      future = api.getCitas();
    });
  }

  void _abrirFormulario(Cita cita) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CitaFormPage(cita: cita)),
    ).then((_) => _cargar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas médicas')),
      body: FutureBuilder<List<Cita>>(
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
            return const Center(child: Text('No hay citas'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return ListTile(
                title: Text(item.paciente),
                subtitle: Text('Dr. ${item.doctor}  •  ${fechaBonita(item.fechaHora)}'),
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
