import 'package:flutter/material.dart';

class PupilStateScreen extends StatefulWidget {
  const PupilStateScreen({super.key});

  @override
  State<PupilStateScreen> createState() => _PupilStateScreenState();
}

class _PupilStateScreenState extends State<PupilStateScreen> {
  String _searchQuery = '';
  String _selectedCourse = 'all';
  String _selectedStatus = 'all';

  final List<Map<String, dynamic>> _pupils = [
    {
      'name': 'Juan Pérez',
      'initials': 'JP',
      'course': '1° Básico A',
      'status': 'En Ruta',
      'lastUpdate': '14:30'
    },
    {
      'name': 'María González',
      'initials': 'MG',
      'course': '2° Básico B',
      'status': 'Retrasado',
      'lastUpdate': '14:15'
    },
    {
      'name': 'Pedro Soto',
      'initials': 'PS',
      'course': '3° Básico A',
      'status': 'Ausente',
      'lastUpdate': '08:30'
    },
    {
      'name': 'Ana Silva',
      'initials': 'AS',
      'course': '1° Básico A',
      'status': 'Pendiente',
      'lastUpdate': '13:45'
    },
    {
      'name': 'Lucas Ramírez',
      'initials': 'LR',
      'course': '2° Básico B',
      'status': 'En Ruta',
      'lastUpdate': '14:20'
    }
  ];

  List<Map<String, dynamic>> get filteredPupils {
    return _pupils.where((pupil) {
      final matchesSearch =
          pupil['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCourse =
          _selectedCourse == 'all' || pupil['course'] == _selectedCourse;
      final matchesStatus =
          _selectedStatus == 'all' || pupil['status'] == _selectedStatus;
      return matchesSearch && matchesCourse && matchesStatus;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En Ruta':
        return Colors.green;
      case 'Retrasado':
        return Colors.orange;
      case 'Ausente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Image.network(
                'https://www.martilor.com/wp-content/uploads/2023/11/logo_corto.png',
                height: 40,
              ),
              const SizedBox(width: 12),
              const Text('Estado de Pupilos'),
            ],
          ),
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
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildStatusSummary(),
            ),
            SingleChildScrollView(
              child: _buildFilters(),
            ),
            Expanded(
              child: _buildPupilList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSummary() {
    final statusCounts = {
      'En Ruta': 0,
      'Retrasado': 0,
      'Ausente': 0,
      'Pendiente': 0,
    };

    for (var pupil in _pupils) {
      statusCounts[pupil['status']] = (statusCounts[pupil['status']] ?? 0) + 1;
    }

    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusIndicator(
                'En Ruta', statusCounts['En Ruta'].toString(), Colors.green),
            const SizedBox(width: 8),
            _buildStatusIndicator('Retrasados',
                statusCounts['Retrasado'].toString(), Colors.orange),
            const SizedBox(width: 8),
            _buildStatusIndicator(
                'Ausentes', statusCounts['Ausente'].toString(), Colors.red),
            const SizedBox(width: 8),
            _buildStatusIndicator('Pendientes',
                statusCounts['Pendiente'].toString(), Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
          ),
          child: Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    final courses = [
      'Todos los cursos',
      '1° Básico A',
      '2° Básico B',
      '3° Básico A'
    ];
    final statuses = [
      'Todos los estados',
      'En Ruta',
      'Retrasado',
      'Ausente',
      'Pendiente'
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
                hintText: 'Buscar alumno...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCourse == 'all'
                          ? 'Todos los cursos'
                          : _selectedCourse,
                      isDense: true,
                      dropdownColor: Colors.purple.shade900,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        labelText: 'Curso',
                        labelStyle:
                            const TextStyle(color: Colors.white, fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                      items: courses
                          .map((course) => DropdownMenuItem(
                                value: course,
                                child: Text(course,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedCourse =
                          value == 'Todos los cursos' ? 'all' : value!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus == 'all'
                          ? 'Todos los estados'
                          : _selectedStatus,
                      isDense: true,
                      dropdownColor: Colors.purple.shade900,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        labelText: 'Estado',
                        labelStyle:
                            const TextStyle(color: Colors.white, fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                      items: statuses
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedStatus =
                          value == 'Todos los estados' ? 'all' : value!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPupilList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredPupils.length,
      itemBuilder: (context, index) {
        final pupil = filteredPupils[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Text(
                pupil['initials'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              pupil['name'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pupil['course'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(pupil['status']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: _getStatusColor(pupil['status'])),
                      ),
                      child: Text(
                        pupil['status'],
                        style: TextStyle(
                          color: _getStatusColor(pupil['status']),
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      'Última act.: ${pupil['lastUpdate']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon:
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
