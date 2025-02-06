import 'package:flutter/material.dart';

// Student Model
class Student {
  final String id;
  String name;
  String course;
  String studentId;

  Student({
    required this.id,
    required this.name,
    required this.course,
    required this.studentId,
  });

  Student copyWith({
    String? name,
    String? course,
    String? studentId,
  }) {
    return Student(
      id: this.id,
      name: name ?? this.name,
      course: course ?? this.course,
      studentId: studentId ?? this.studentId,
    );
  }
}

// Student Management Screen with StatefulWidget
class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  // Lista de estudiantes
  List<Student> students = [];
  // Filtro de búsqueda
  String searchQuery = '';
  String selectedCourse = 'all';

  @override
  void initState() {
    super.initState();
    // Cargar datos de ejemplo
    _loadSampleData();
  }

  void _loadSampleData() {
    students = List.generate(
      5,
      (index) => Student(
        id: 'id_$index',
        name: 'Estudiante ${index + 1}',
        course: '1°A',
        studentId: '1234${index + 1}',
      ),
    );
  }

  // Crear estudiante
  void _addStudent() {
    showDialog(
      context: context,
      builder: (context) => StudentFormDialog(
        onSubmit: (String name, String course, String studentId) {
          setState(() {
            students.add(Student(
              id: DateTime.now().toString(),
              name: name,
              course: course,
              studentId: studentId,
            ));
          });
        },
      ),
    );
  }

  // Editar estudiante
  void _editStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) => StudentFormDialog(
        initialName: student.name,
        initialCourse: student.course,
        initialStudentId: student.studentId,
        onSubmit: (String name, String course, String studentId) {
          setState(() {
            final index = students.indexWhere((s) => s.id == student.id);
            if (index != -1) {
              students[index] = student.copyWith(
                name: name,
                course: course,
                studentId: studentId,
              );
            }
          });
        },
      ),
    );
  }

  // Eliminar estudiante
  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar a ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                students.removeWhere((s) => s.id == student.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Alumnos'),
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
            _buildFilters(),
            const SizedBox(height: 16),
            _buildStudentList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudent,
        backgroundColor: Colors.purple.shade900,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Buscar alumno...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.purple.shade900,
                    value: selectedCourse,
                    items: const [
                      DropdownMenuItem(
                          value: 'all', child: Text('Todos los cursos')),
                      DropdownMenuItem(value: '1°A', child: Text('1°A')),
                      DropdownMenuItem(value: '1°B', child: Text('1°B')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Curso',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    final filteredStudents = students.where((student) {
      final matchesSearch = student.name
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          student.studentId.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCourse =
          selectedCourse == 'all' || student.course == selectedCourse;
      return matchesSearch && matchesCourse;
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              student.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Curso: ${student.course} | ID: ${student.studentId}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Eliminar'),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _editStudent(student);
                } else if (value == 'delete') {
                  _deleteStudent(student);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

// Dialog para crear/editar estudiantes
class StudentFormDialog extends StatefulWidget {
  final Function(String name, String course, String studentId) onSubmit;
  final String? initialName;
  final String? initialCourse;
  final String? initialStudentId;

  const StudentFormDialog({
    super.key,
    required this.onSubmit,
    this.initialName,
    this.initialCourse,
    this.initialStudentId,
  });

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  late TextEditingController nameController;
  late TextEditingController courseController;
  late TextEditingController studentIdController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName ?? '');
    courseController = TextEditingController(text: widget.initialCourse ?? '');
    studentIdController =
        TextEditingController(text: widget.initialStudentId ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null
          ? 'Nuevo Estudiante'
          : 'Editar Estudiante'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: courseController,
            decoration: const InputDecoration(labelText: 'Curso'),
          ),
          TextField(
            controller: studentIdController,
            decoration: const InputDecoration(labelText: 'ID Estudiante'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmit(
              nameController.text,
              courseController.text,
              studentIdController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
