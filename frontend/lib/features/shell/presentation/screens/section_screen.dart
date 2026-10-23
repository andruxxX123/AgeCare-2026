import 'package:flutter/material.dart';

/// Vista reutilizable para las áreas que comparten el shell de navegación.
/// Mantiene la interfaz coherente mientras cada dominio incorpora sus
/// servicios y permisos específicos.
class SectionScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<String> capabilities;

  const SectionScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.capabilities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(icon, size: 52, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          for (final capability in capabilities)
            Card(
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
                title: Text(capability),
              ),
            ),
        ],
      ),
    );
  }
}
