import 'package:flutter/material.dart';
import 'package:medicity_flutter/page/consulta_page.dart';
import 'package:medicity_flutter/page/diagnosticos_page.dart';
import 'package:medicity_flutter/page/doctores_page.dart';
import 'package:medicity_flutter/page/pacientes_page.dart';
import 'package:medicity_flutter/page/citas_medicas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicity')),
      body: ListView(
        children: [
          _item(context, 'Consultas', const ConsultaPage()),
          _item(context, 'Doctores', const DoctoresPage()),
          _item(context, 'Citas médicas', const CitasMedicasPage()),
          _item(context, 'Pacientes', const PacientesPage()),
          _item(context, 'Diagnósticos', const DiagnosticosPage()),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String titulo, Widget page) {
    return ListTile(
      title: Text(titulo),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
