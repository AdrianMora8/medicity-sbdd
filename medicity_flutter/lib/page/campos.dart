import 'package:flutter/material.dart';

InputDecoration campo(String label) {
  return InputDecoration(labelText: label);
}

Widget comboId({
  required String label,
  required int? valor,
  required Map<int, String> opciones,
  required void Function(int?) alCambiar,
}) {
  return DropdownButtonFormField<int>(
    key: ValueKey('$label-$valor'),
    initialValue: opciones.containsKey(valor) ? valor : null,
    decoration: campo(label),
    items: [
      for (final e in opciones.entries)
        DropdownMenuItem(value: e.key, child: Text(e.value)),
    ],
    onChanged: alCambiar,
  );
}

Widget botonGuardar(String texto, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: FilledButton(onPressed: onPressed, child: Text(texto)),
  );
}
