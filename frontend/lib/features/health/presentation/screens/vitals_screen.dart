import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../patients/presentation/providers/patients_providers.dart';
import '../providers/vitals_providers.dart';

/// Registro de signos vitales conectado al módulo health del backend.
class VitalsScreen extends ConsumerStatefulWidget {
  const VitalsScreen({super.key});

  @override
  ConsumerState<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends ConsumerState<VitalsScreen> {
  String? _patientId;

  Future<void> _addVital(String patientId) async {
    final metric = TextEditingController(text: 'presion_arterial');
    final value = TextEditingController();
    final unit = TextEditingController(text: 'mmHg');
    final note = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar medición'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: metric, decoration: const InputDecoration(labelText: 'Métrica (ej. presión_arterial)')),
                TextFormField(controller: value, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Valor'), validator: (v) => double.tryParse(v ?? '') == null ? 'Ingresa un número' : null),
                TextFormField(controller: unit, decoration: const InputDecoration(labelText: 'Unidad')),
                TextFormField(controller: note, decoration: const InputDecoration(labelText: 'Nota (opcional)')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () async {
            if (!(formKey.currentState?.validate() ?? false)) return;
            await ref.read(vitalsRepositoryProvider).create(patientId: patientId, metric: metric.text.trim(), value: double.parse(value.text), unit: unit.text.trim(), note: note.text);
            if (context.mounted) Navigator.pop(context, true);
          }, child: const Text('Guardar')),
        ],
      ),
    );
    metric.dispose(); value.dispose(); unit.dispose(); note.dispose();
    if (created == true) ref.invalidate(patientVitalsProvider(patientId));
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(myPatientsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Salud')),
      body: patients.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(child: Text('No se pudieron cargar los pacientes.')),
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('Añade un paciente para registrar mediciones.'));
          final selected = items.any((item) => item.id == _patientId) ? _patientId! : items.first.id;
          final vitals = ref.watch(patientVitalsProvider(selected));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: DropdownButtonFormField<String>(
                  value: selected,
                  decoration: const InputDecoration(labelText: 'Paciente'),
                  items: [for (final item in items) DropdownMenuItem(value: item.id, child: Text(item.fullName))],
                  onChanged: (value) => setState(() => _patientId = value),
                ),
              ),
              Expanded(
                child: vitals.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => const Center(child: Text('No se pudieron cargar las mediciones.')),
                  data: (records) => records.isEmpty
                      ? const Center(child: Text('Todavía no hay mediciones registradas.'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: records.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final record = records[index];
                            return Card(child: ListTile(title: Text('${record.metric}: ${record.value} ${record.unit}'), subtitle: Text(record.recordedAt.toLocal().toString()), trailing: Text(record.source)));
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: patients.maybeWhen(data: (items) => items.isEmpty ? null : FloatingActionButton.extended(onPressed: () => _addVital(_patientId ?? items.first.id), icon: const Icon(Icons.add), label: const Text('Medición')), orElse: () => null),
    );
  }
}
