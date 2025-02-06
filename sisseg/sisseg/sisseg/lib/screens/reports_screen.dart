import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReportType = 'Calificaciones';
  String _selectedPeriod = 'Semestre 1';
  String _selectedGrade = 'Todos';

  final List<String> _reportTypes = [
    'Calificaciones',
    'Asistencia',
    'Comportamiento',
    'Progreso Académico',
    'Actividades Extracurriculares'
  ];

  final List<String> _periods = ['Semestre 1', 'Semestre 2', 'Anual'];

  final List<String> _grades = [
    'Todos',
    '7° Básico',
    '8° Básico',
    '1° Medio',
    '2° Medio',
    '3° Medio',
    '4° Medio'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://www.martilor.com/wp-content/uploads/2023/11/logo_corto.png',
              height: 40,
            ),
            const SizedBox(width: 12),
            const Text('Informes y Vistas'),
          ],
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterCard(),
              const SizedBox(height: 16),
              _buildGenerateButton(),
              const SizedBox(height: 16),
              _buildReportsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterCard() {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros de Reporte',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Tipo de Reporte',
              _selectedReportType,
              _reportTypes,
              (String? value) {
                if (value != null) {
                  setState(() => _selectedReportType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Período',
              _selectedPeriod,
              _periods,
              (String? value) {
                if (value != null) {
                  setState(() => _selectedPeriod = value);
                }
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Grado',
              _selectedGrade,
              _grades,
              (String? value) {
                if (value != null) {
                  setState(() => _selectedGrade = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.purple.shade900,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return ElevatedButton(
      onPressed: _generateReport,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade800,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.file_download, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Generar Reporte',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    return Expanded(
      child: Card(
        color: Colors.white.withOpacity(0.1),
        child: ListView.separated(
          itemCount: 10,
          separatorBuilder: (context, index) => Divider(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(
                Icons.description,
                color: Colors.white,
              ),
              title: Text(
                'Reporte de ${_reportTypes[index % _reportTypes.length]}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Generado el ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                    onPressed: () => _viewReport(index),
                    tooltip: 'Ver reporte',
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white),
                    onPressed: () => _downloadReport(index),
                    tooltip: 'Descargar reporte',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple.shade900,
        title: const Text(
          'Generando Reporte',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Generando reporte de $_selectedReportType para $_selectedGrade',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte generado exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _viewReport(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple.shade900,
        title: Text(
          'Reporte ${index + 1}',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo: ${_reportTypes[index % _reportTypes.length]}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Período: $_selectedPeriod',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Grado: $_selectedGrade',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReport(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando reporte ${index + 1}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
