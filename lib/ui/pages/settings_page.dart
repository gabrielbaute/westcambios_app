import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _enableAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Alertas de Tasa"),
            subtitle: const Text("Activar chequeo en segundo plano"),
            value: _enableAlerts,
            onChanged: (val) => setState(() => _enableAlerts = val),
          ),
          const Divider(),
          const ListTile(
            title: Text("Versión de la App"),
            trailing: Text("1.0.0"),
          ),
        ],
      ),
    );
  }
}
