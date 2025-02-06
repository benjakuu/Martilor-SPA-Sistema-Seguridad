import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<ActivityLog> _activities = [
    ActivityLog(
      title: 'Actualización de perfil',
      description: 'Se actualizaron datos personales',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: ActivityType.profile,
    ),
    ActivityLog(
      title: 'Documento subido',
      description: 'Se subió documento',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: ActivityType.document,
    ),
  ];

  DateTime? _startDate;
  DateTime? _endDate;
  ActivityType? _filterType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        backgroundColor: Colors.purple.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.purple.shade900, const Color(0xFF1A1A2E)],
          ),
        ),
        child: ListView.builder(
          itemCount: _filteredActivities.length,
          itemBuilder: (context, index) {
            final activity = _filteredActivities[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white.withOpacity(0.1),
              child: ListTile(
                leading: _getActivityIcon(activity.type),
                title: Text(
                  activity.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.description,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      _formatDate(activity.date),
                      style: TextStyle(color: Colors.purple.shade200),
                    ),
                  ],
                ),
                onTap: () => _showActivityDetails(activity),
              ),
            );
          },
        ),
      ),
    );
  }

  List<ActivityLog> get _filteredActivities {
    return _activities.where((activity) {
      if (_startDate != null && activity.date.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && activity.date.isAfter(_endDate!)) {
        return false;
      }
      if (_filterType != null && activity.type != _filterType) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar Actividades'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Rango de fechas'),
              onTap: () async {
                final DateTimeRange? dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (dateRange != null) {
                  setState(() {
                    _startDate = dateRange.start;
                    _endDate = dateRange.end;
                  });
                }
              },
            ),
            DropdownButton<ActivityType>(
              value: _filterType,
              hint: const Text('Tipo de actividad'),
              items: ActivityType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _filterType = value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _startDate = null;
                _endDate = null;
                _filterType = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Limpiar Filtros'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(ActivityLog activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descripción: ${activity.description}'),
            const SizedBox(height: 8),
            Text('Fecha: ${_formatDate(activity.date)}'),
            const SizedBox(height: 8),
            Text('Tipo: ${activity.type.toString().split('.').last}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _getActivityIcon(ActivityType type) {
    IconData iconData;
    switch (type) {
      case ActivityType.profile:
        iconData = Icons.person;
        break;
      case ActivityType.document:
        iconData = Icons.description;
        break;
      case ActivityType.settings:
        iconData = Icons.settings;
        break;
    }
    return Icon(iconData, color: Colors.white);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

enum ActivityType { profile, document, settings }

class ActivityLog {
  final String title;
  final String description;
  final DateTime date;
  final ActivityType type;

  ActivityLog({
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });
}
