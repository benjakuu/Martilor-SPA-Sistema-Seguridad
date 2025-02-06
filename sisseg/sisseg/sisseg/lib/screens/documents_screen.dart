import 'package:flutter/material.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final List<Document> _documents = [
    Document(
      name: 'Factura Enero 2024',
      type: 'PDF',
      size: '1.2 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Document(
      name: 'Contrato',
      type: 'DOC',
      size: '2.8 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentos'),
        backgroundColor: Colors.purple.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DocumentSearchDelegate(_documents),
              );
            },
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
          itemCount: _documents.length,
          itemBuilder: (context, index) {
            final document = _documents[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white.withOpacity(0.1),
              child: ListTile(
                leading: _getFileTypeIcon(document.type),
                title: Text(
                  document.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${document.type} - ${document.size}\nSubido: ${_formatDate(document.uploadDate)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) => _handleDocumentAction(value, document),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'download',
                      child: Text('Descargar'),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Text('Compartir'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
                onTap: () => _previewDocument(document),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadDocument,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getFileTypeIcon(String type) {
    IconData iconData;
    switch (type.toUpperCase()) {
      case 'PDF':
        iconData = Icons.picture_as_pdf;
        break;
      case 'DOC':
        iconData = Icons.description;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }
    return Icon(iconData, color: Colors.white);
  }

  void _uploadDocument() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subir Documento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre del documento',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simular proceso de carga
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Documento subido exitosamente')),
                );
              },
              child: const Text('Seleccionar archivo'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDocumentAction(String action, Document document) {
    switch (action) {
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Descargando ${document.name}...')),
        );
        break;
      case 'share':
        break;
      case 'delete':
        _deleteDocument(document);
        break;
    }
  }

  void _deleteDocument(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de querer eliminar ${document.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _documents.remove(document);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Documento eliminado')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _previewDocument(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.name),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_present, size: 50),
            SizedBox(height: 16),
            Text('Vista previa no disponible'),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Document {
  final String name;
  final String type;
  final String size;
  final DateTime uploadDate;

  Document({
    required this.name,
    required this.type,
    required this.size,
    required this.uploadDate,
  });
}

class DocumentSearchDelegate extends SearchDelegate {
  final List<Document> documents;

  DocumentSearchDelegate(this.documents);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = documents
        .where(
          (doc) => doc.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final document = results[index];
        return ListTile(
          title: Text(document.name),
          subtitle: Text('${document.type} - ${document.size}'),
          leading: const Icon(Icons.file_present),
          onTap: () => close(context, document),
        );
      },
    );
  }
}
