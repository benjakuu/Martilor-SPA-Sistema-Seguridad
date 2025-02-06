import 'package:flutter/material.dart';
import '../models/audit_log.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  List<AuditAction> selectedActions = [];
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = '';

  final List<AuditLog> auditLogs = [
    AuditLog(
      id: '1',
      timestamp: DateTime.now(),
      userId: 'user123',
      userName: 'Juan Pérez',
      action: AuditAction.login,
      description: 'Inicio de sesión exitoso',
      ipAddress: '192.168.1.1',
    ),
  ];

  List<AuditLog> get filteredLogs {
    return auditLogs.where((log) {
      bool matchesAction =
          selectedActions.isEmpty || selectedActions.contains(log.action);
      bool matchesDate =
          (startDate == null || log.timestamp.isAfter(startDate!)) &&
              (endDate == null || log.timestamp.isBefore(endDate!));
      bool matchesSearch = searchQuery.isEmpty ||
          log.userName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.description.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesAction && matchesDate && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Auditoría'),
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
            _buildFilters(),
            Expanded(
              child: _buildAuditList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      color: Colors.purple.shade900.withOpacity(0.1),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.purple.shade900.withOpacity(0.2),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildActionFilters(),
            const SizedBox(height: 16),
            _buildDateFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AuditAction.values.map((action) {
        bool isSelected = selectedActions.contains(action);
        return FilterChip(
          label: Text(
            action.toString().split('.').last,
            style: TextStyle(
              color: isSelected ? Colors.purple.shade900 : Colors.white,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedActions.add(action);
              } else {
                selectedActions.remove(action);
              }
            });
          },
          backgroundColor: Colors.purple.shade900.withOpacity(0.1),
          selectedColor: Colors.white,
        );
      }).toList(),
    );
  }

  Widget _buildDateFilters() {
    return Row(
      children: [
        Expanded(
          child: _buildDatePicker(
            'Fecha inicial',
            startDate,
            (date) => setState(() => startDate = date),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDatePicker(
            'Fecha final',
            endDate,
            (date) => setState(() => endDate = date),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
      String label, DateTime? value, Function(DateTime?) onChanged) {
    return TextButton.icon(
      icon: const Icon(Icons.calendar_today, color: Colors.white),
      label: Text(
        value?.toString() ?? label,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.purple.shade900,
                  onPrimary: Colors.white,
                  surface: const Color(0xFF1A1A2E),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        onChanged(date);
      },
    );
  }

  Widget _buildAuditList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final log = filteredLogs[index];
        return Card(
          color: Colors.purple.shade900.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              log.actionText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  log.description,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Usuario: ${log.userName} | IP: ${log.ipAddress}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Fecha: ${log.formattedTimestamp}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () => _showLogDetails(log),
            ),
          ),
        );
      },
    );
  }

  void _showLogDetails(AuditLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple.shade900,
        title: const Text(
          'Detalles del Registro',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID:', log.id),
            _buildDetailRow('Acción:', log.actionText),
            _buildDetailRow('Usuario:', log.userName),
            _buildDetailRow('ID Usuario:', log.userId),
            _buildDetailRow('Fecha:', log.formattedTimestamp),
            _buildDetailRow('IP:', log.ipAddress),
            _buildDetailRow('Descripción:', log.description),
            if (log.details != null) _buildDetailRow('Detalles:', log.details!),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
