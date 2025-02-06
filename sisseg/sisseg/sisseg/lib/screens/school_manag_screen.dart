import 'package:flutter/material.dart';

// School Model
class School {
  final String id;
  String name;
  String address;
  String phone;
  String email;
  String director;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.director,
  });

  School copyWith({
    String? name,
    String? address,
    String? phone,
    String? email,
    String? director,
  }) {
    return School(
      id: this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      director: director ?? this.director,
    );
  }
}

class SchoolManagementScreen extends StatefulWidget {
  const SchoolManagementScreen({super.key});

  @override
  State<SchoolManagementScreen> createState() => _SchoolManagementScreenState();
}

class _SchoolManagementScreenState extends State<SchoolManagementScreen> {
  List<School> schools = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    schools = List.generate(
      5,
      (index) => School(
        id: 'id_$index',
        name: 'Colegio ${index + 1}',
        address: 'Dirección del colegio ${index + 1}',
        phone: '123-456-${index + 1}',
        email: 'colegio${index + 1}@example.com',
        director: 'Director ${index + 1}',
      ),
    );
  }

  // Crear colegio
  void _addSchool() {
    showDialog(
      context: context,
      builder: (context) => SchoolFormDialog(
        onSubmit: (String name, String address, String phone, String email,
            String director) {
          setState(() {
            schools.add(School(
              id: DateTime.now().toString(),
              name: name,
              address: address,
              phone: phone,
              email: email,
              director: director,
            ));
          });
        },
      ),
    );
  }

  // Editar colegio
  void _editSchool(School school) {
    showDialog(
      context: context,
      builder: (context) => SchoolFormDialog(
        initialName: school.name,
        initialAddress: school.address,
        initialPhone: school.phone,
        initialEmail: school.email,
        initialDirector: school.director,
        onSubmit: (String name, String address, String phone, String email,
            String director) {
          setState(() {
            final index = schools.indexWhere((s) => s.id == school.id);
            if (index != -1) {
              schools[index] = school.copyWith(
                name: name,
                address: address,
                phone: phone,
                email: email,
                director: director,
              );
            }
          });
        },
      ),
    );
  }

  // Eliminar colegio
  void _deleteSchool(School school) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar ${school.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                schools.removeWhere((s) => s.id == school.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Colegios'),
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
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildSchoolList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSchool,
        backgroundColor: Colors.purple.shade900,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Buscar colegio...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSchoolList() {
    final filteredSchools = schools.where((school) {
      return school.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          school.address.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredSchools.length,
      itemBuilder: (context, index) {
        final school = filteredSchools[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ExpansionTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.school, color: Colors.white),
            ),
            title: Text(
              school.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              school.address,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _editSchool(school),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteSchool(school),
                ),
              ],
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Director: ${school.director}',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Teléfono: ${school.phone}',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Email: ${school.email}',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Dialog para crear/editar colegios
class SchoolFormDialog extends StatefulWidget {
  final Function(String name, String address, String phone, String email,
      String director) onSubmit;
  final String? initialName;
  final String? initialAddress;
  final String? initialPhone;
  final String? initialEmail;
  final String? initialDirector;

  const SchoolFormDialog({
    super.key,
    required this.onSubmit,
    this.initialName,
    this.initialAddress,
    this.initialPhone,
    this.initialEmail,
    this.initialDirector,
  });

  @override
  State<SchoolFormDialog> createState() => _SchoolFormDialogState();
}

class _SchoolFormDialogState extends State<SchoolFormDialog> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController directorController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    addressController =
        TextEditingController(text: widget.initialAddress ?? '');
    phoneController = TextEditingController(text: widget.initialPhone ?? '');
    emailController = TextEditingController(text: widget.initialEmail ?? '');
    directorController =
        TextEditingController(text: widget.initialDirector ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    directorController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    if (!value.contains('@')) {
      return 'Ingrese un email válido';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.initialName == null ? 'Nuevo Colegio' : 'Editar Colegio'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Colegio'),
                validator: _validateRequired,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: _validateRequired,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: _validateRequired,
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: directorController,
                decoration: const InputDecoration(labelText: 'Director'),
                validator: _validateRequired,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                nameController.text,
                addressController.text,
                phoneController.text,
                emailController.text,
                directorController.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
