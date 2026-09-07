int asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

int? asIntN(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

Map<String, dynamic> minusculas(Map<String, dynamic> json) {
  return {for (final e in json.entries) e.key.toLowerCase(): e.value};
}

String fechaBonita(String raw) {
  if (raw.isEmpty) return '';
  try {
    final d = DateTime.parse(raw);
    final dia = d.day.toString().padLeft(2, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final hora = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${d.year} $hora:$min';
  } catch (_) {
    return raw;
  }
}
