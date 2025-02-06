import 'package:flutter/material.dart';

class adminFuctionScreen extends StatelessWidget {
  const adminFuctionScreen({super.key});

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
            const Text('Panel de Control Admin'),
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
                  '¡Bienvenido, Administrador!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
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
                    'Gestión de Colegios',
                    Icons.school,
                    () => Navigator.pushNamed(context, '/schools'),
                  ),
                  _buildMenuCard(
                    context,
                    'Gestión de Alumnos',
                    Icons.people,
                    () => Navigator.pushNamed(context, '/students'),
                  ),
                  _buildMenuCard(
                    context,
                    'Puntos de Mapeo',
                    Icons.map,
                    () => Navigator.pushNamed(context, '/mappingpoints'),
                  ),
                  _buildMenuCard(
                    context,
                    'Reglas de Mapeo',
                    Icons.rule,
                    () => Navigator.pushNamed(context, '/mappingrules'),
                  ),
                  _buildMenuCard(
                    context,
                    'Informes y Vistas',
                    Icons.analytics,
                    () => Navigator.pushNamed(context, '/reports'),
                  ),
                  _buildMenuCard(
                    context,
                    'Configuración',
                    Icons.settings,
                    () => Navigator.pushNamed(context, '/settings'),
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
                      'Menú Administrador',
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
                'Gestión de Colegios',
                Icons.school,
                () => Navigator.pushNamed(context, '/schools'),
              ),
              _buildDrawerItem(
                context,
                'Gestión de Alumnos',
                Icons.people,
                () => Navigator.pushNamed(context, '/students'),
              ),
              _buildDrawerItem(
                context,
                'Puntos de Mapeo',
                Icons.map,
                () => Navigator.pushNamed(context, '/mappingpoints'),
              ),
              _buildDrawerItem(
                context,
                'Reglas de Mapeo',
                Icons.rule,
                () => Navigator.pushNamed(context, '/mappingrules'),
              ),
              _buildDrawerItem(
                context,
                'Informes y Vistas',
                Icons.analytics,
                () => Navigator.pushNamed(context, '/reports'),
              ),
              _buildDrawerItem(
                context,
                'Registro de Auditoria',
                Icons.history,
                () => Navigator.pushNamed(context, '/auditreg'),
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
