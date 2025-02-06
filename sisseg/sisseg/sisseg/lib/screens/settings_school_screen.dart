import 'package:flutter/material.dart';

class SchoolSettingsScreen extends StatefulWidget {
  const SchoolSettingsScreen({super.key});

  @override
  State<SchoolSettingsScreen> createState() => _SchoolSettingsScreenState();
}

class _SchoolSettingsScreenState extends State<SchoolSettingsScreen> {
  bool _enableNotifications = true;
  bool _enableAutomaticReports = true;
  String _selectedLanguage = 'Español';
  String _selectedTheme = 'Oscuro';

  final List<String> _languages = ['Español', 'English', 'Português'];
  final List<String> _themes = ['Claro', 'Oscuro', 'Sistema'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.purple.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.purple.shade900,
              const Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSection(
              'Configuración General',
              [
                _buildDropdownTile(
                  'Idioma',
                  _selectedLanguage,
                  _languages,
                  Icons.language,
                  (String? value) {
                    if (value != null) {
                      setState(() => _selectedLanguage = value);
                    }
                  },
                ),
                _buildDropdownTile(
                  'Tema',
                  _selectedTheme,
                  _themes,
                  Icons.palette,
                  (String? value) {
                    if (value != null) {
                      setState(() => _selectedTheme = value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Notificaciones',
              [
                _buildSwitchTile(
                  'Activar Notificaciones',
                  'Recibir alertas y recordatorios',
                  Icons.notifications,
                  _enableNotifications,
                  (value) => setState(() => _enableNotifications = value),
                ),
                _buildSwitchTile(
                  'Reportes Automáticos',
                  'Generar informes periódicamente',
                  Icons.auto_awesome,
                  _enableAutomaticReports,
                  (value) => setState(() => _enableAutomaticReports = value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Acciones',
              [
                _buildActionTile(
                  'Respaldar Datos',
                  'Crear copia de seguridad',
                  Icons.backup,
                  _backupData,
                ),
                _buildActionTile(
                  'Restaurar Datos',
                  'Recuperar copia de seguridad',
                  Icons.restore,
                  _restoreData,
                ),
                _buildActionTile(
                  'Limpiar Caché',
                  'Liberar espacio',
                  Icons.cleaning_services,
                  _clearCache,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.purple.shade200,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> items,
    IconData icon,
    void Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Colors.purple.shade900,
          style: const TextStyle(color: Colors.white),
          underline: Container(),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      onTap: onTap,
    );
  }

  void _backupData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciando respaldo de datos...')),
    );
  }

  void _restoreData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Datos'),
        content: const Text(
            '¿Está seguro que desea restaurar los datos? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restaurando datos...')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Caché'),
        content: const Text(
            '¿Está seguro que desea limpiar el caché? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Limpiando caché...')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
