import 'package:flutter/material.dart';

class MappingPoint {
  final String id;
  final double latitude;
  final double longitude;
  final String name;

  MappingPoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
  });
}

class MappingPointsScreen extends StatefulWidget {
  const MappingPointsScreen({super.key});

  @override
  State<MappingPointsScreen> createState() => _MappingPointsScreenState();
}

class _MappingPointsScreenState extends State<MappingPointsScreen> {
  final List<MappingPoint> points = [];
  double _scale = 1.0;
  Offset _position = Offset.zero;
  Offset? _startingFocalPoint;
  Offset? _previousOffset;
  double _previousScale = 1.0;

  void _addPoint(MappingPoint point) {
    setState(() {
      points.add(point);
    });
  }

  void _deletePoint(String id) {
    setState(() {
      points.removeWhere((point) => point.id == id);
    });
  }

  void _showAddPointDialog() {
    final nameController = TextEditingController();
    final latController = TextEditingController();
    final longController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Nuevo Punto', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: latController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Latitud',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: longController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Longitud',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  latController.text.isNotEmpty &&
                  longController.text.isNotEmpty) {
                _addPoint(MappingPoint(
                  id: DateTime.now().toString(),
                  name: nameController.text,
                  latitude: double.parse(latController.text),
                  longitude: double.parse(longController.text),
                ));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade900,
            ),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de Mapeo'),
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
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onScaleStart: (details) {
                    _startingFocalPoint = details.focalPoint;
                    _previousOffset = _position;
                    _previousScale = _scale;
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      if (details.scale != 1.0) {
                        _scale =
                            (_previousScale * details.scale).clamp(0.5, 4.0);
                      } else if (_startingFocalPoint != null) {
                        final delta = details.focalPoint - _startingFocalPoint!;
                        _position = _previousOffset! + delta;
                      }
                    });
                  },
                  onTapUp: (details) {
                    _showAddPointDialog();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: _MapPainter(
                        points: points,
                        scale: _scale,
                        position: _position,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildPointsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPointDialog,
        backgroundColor: Colors.purple.shade900,
        child: const Icon(Icons.add_location),
      ),
    );
  }

  Widget _buildPointsList() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: points.length,
        itemBuilder: (context, index) {
          final point = points[index];
          return Card(
            color: Colors.white.withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white),
              title: Text(
                point.name,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Lat: ${point.latitude}, Long: ${point.longitude}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Eliminar'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _deletePoint(point.id);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<MappingPoint> points;
  final double scale;
  final Offset position;

  _MapPainter({
    required this.points,
    required this.scale,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0;

    final gridSize = 50.0 * scale;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x + position.dx % gridSize, 0),
        Offset(x + position.dx % gridSize, size.height),
        gridPaint,
      );
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y + position.dy % gridSize),
        Offset(size.width, y + position.dy % gridSize),
        gridPaint,
      );
    }

    final pointPaint = Paint()
      ..color = Colors.purple[900]!
      ..style = PaintingStyle.fill;

    for (var point in points) {
      final x = (point.longitude + 180) / 360 * size.width;
      final y = (90 - point.latitude) / 180 * size.height;

      final transformedX = x * scale + position.dx;
      final transformedY = y * scale + position.dy;

      canvas.drawCircle(
        Offset(transformedX, transformedY),
        8 * scale,
        pointPaint,
      );

      final textSpan = TextSpan(
        text: point.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12 * scale,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(transformedX + 10 * scale, transformedY - 10 * scale),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.scale != scale ||
        oldDelegate.position != position;
  }
}
