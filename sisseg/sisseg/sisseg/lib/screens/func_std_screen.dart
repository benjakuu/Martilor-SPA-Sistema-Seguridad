import 'package:flutter/material.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

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
            const Text('Panel de Estudiante'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '¡Bienvenido, Estudiante!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Llamados de Atención Activos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2 llamados de atención pendientes',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildMenuCard(
                    context,
                    'Mis Restricciones',
                    Icons.block,
                    () => Navigator.pushNamed(context, '/restrictions'),
                  ),
                  _buildMenuCard(
                    context,
                    'Llamados de Atención',
                    Icons.warning,
                    () => Navigator.pushNamed(context, '/warnings'),
                  ),
                  _buildMenuCard(
                    context,
                    'Datos Personales',
                    Icons.person,
                    () => Navigator.pushNamed(context, '/profile'),
                  ),
                  _buildMenuCard(
                    context,
                    'Notificaciones',
                    Icons.notifications,
                    () => Navigator.pushNamed(context, '/notifications'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.purple.shade900,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple.shade800,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://www.martilor.com/wp-content/uploads/2023/11/logo_corto.png',
                      height: 60,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Menú de Estudiante',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                context,
                'Inicio',
                Icons.home,
                () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                context,
                'Mis Restricciones',
                Icons.block,
                () => Navigator.pushNamed(context, '/restrictions'),
              ),
              _buildDrawerItem(
                context,
                'Llamados de Atención',
                Icons.warning,
                () => Navigator.pushNamed(context, '/warnings'),
              ),
              _buildDrawerItem(
                context,
                'Perfil',
                Icons.person,
                () => Navigator.pushNamed(context, '/profile'),
              ),
              _buildDrawerItem(
                context,
                'Ajustes',
                Icons.settings,
                () => Navigator.pushNamed(context, '/dashboard'),
              ),
              _buildDrawerItem(
                context,
                'Cerrar Sesión',
                Icons.exit_to_app,
                () => Navigator.pushReplacementNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
