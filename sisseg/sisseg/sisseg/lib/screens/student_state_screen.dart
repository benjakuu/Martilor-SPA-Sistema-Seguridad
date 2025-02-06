import 'package:flutter/material.dart';

class PupilStatusScreen extends StatelessWidget {
  const PupilStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Pupilos'),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información general del pupilo
                Card(
                  elevation: 4,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información General',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Nombre:', 'Juan Pérez'),
                        _buildInfoRow('Edad:', '15 años'),
                        _buildInfoRow('Grado:', '3° Medio'),
                        _buildInfoRow('Tutor:', 'Ignacio Perez'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Progreso académico
                Card(
                  elevation: 4,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progreso Académico',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProgressBar('Matemáticas', 0.85),
                        _buildProgressBar('Lenguaje', 0.75),
                        _buildProgressBar('Ciencias', 0.90),
                        _buildProgressBar('Historia', 0.80),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Asistencia
                Card(
                  elevation: 4,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Asistencia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAttendanceStats(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Próximos eventos
                Card(
                  elevation: 4,
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Próximos Eventos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navegar a la vista detallada de eventos
                              },
                              child: const Text('Ver todos'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildEventItem(
                          'Entrega de Proyecto',
                          'Matemáticas',
                          '15 Ene 2025',
                        ),
                        _buildEventItem(
                          'Examen Parcial',
                          'Ciencias',
                          '18 Ene 2025',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Generar informe
          _generateReport(context);
        },
        backgroundColor: Colors.purple.shade900,
        icon: const Icon(Icons.description),
        label: const Text('Generar Informe'),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String subject, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subject),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.purple.shade900,
          ),
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text('${(progress * 100).toInt()}%'),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAttendanceStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAttendanceItem(
            'Asistencias', '90%', Icons.check_circle, Colors.green),
        _buildAttendanceItem(
            'Tardanzas', '5%', Icons.access_time, Colors.orange),
        _buildAttendanceItem('Faltas', '5%', Icons.cancel, Colors.red),
      ],
    );
  }

  Widget _buildAttendanceItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildEventItem(String title, String subject, String date) {
    return ListTile(
      leading: const Icon(Icons.event),
      title: Text(title),
      subtitle: Text(subject),
      trailing: Text(date),
    );
  }

  void _generateReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generar Informe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Informe PDF'),
              onTap: () {
                // Generar PDF
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Informe Excel'),
              onTap: () {
                // Generar Excel
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
